# frozen_string_literal: true

require 'log4r'
module VagrantPlugins
  module ProviderZone
    module Action
      # This is used to package the VM into a box
      class Package
        def initialize(app, env)
          @logger = Log4r::Logger.new('vagrant_zones::action::import')
          @app = app
          @executor = Executor::Exec.new
          @pfexec = if Process.uid.zero?
                      ''
                    elsif system('sudo -v')
                      'sudo'
                    else
                      'pfexec'
                    end
          env['package.output'] ||= 'package.box'
        end

        def execute(*cmd, **opts, &block)
          @executor.execute(*cmd, **opts, &block)
        end

        def call(env)
          @machine = env[:machine]
          @driver = @machine.provider.driver
          config = @machine.provider_config
          name = @machine.name
          boxname = env['package.output']
          boxshortname = config.boxshortname
          raise "#{boxname}: Already exists" if File.exist?(boxname)

          tmp_dir = "#{Dir.pwd}/_tmp_package"
          tmp_img = "#{tmp_dir}/box.zss"
          Dir.mkdir(tmp_dir) unless File.exist?(tmp_dir)
          datasetpath = "#{config.boot['array']}/#{config.boot['dataset']}/#{name}"
          t = Time.new
          dash = '-'
          colon = ':'
          datetime = t.year.to_s + dash + t.month.to_s + dash + t.day.to_s + dash + t.hour.to_s + colon + t.min.to_s + colon + t.sec.to_s
          env[:ui].info("==> #{name}: Creating a Snapshot of the box.")
          snapshot_create(datasetpath, datetime)
          env[:ui].info("==> #{name}: Sending Snapshot to ZFS Send Sream image.")
          snapshot_send(datasetpath, tmp_img, datetime)
          env[:ui].info("==> #{name}: Remove templated snapshot.")
          snapshot_delete(datasetpath, datetime)
          extra = ''
          @tmp_include = "#{tmp_dir}/_include"
          if env['package.include']
            extra = './_include'
            Dir.mkdir(@tmp_include)
            env['package.include'].each do |f|
              env[:ui].info("Including user file: #{f}")
              FileUtils.cp(f, @tmp_include)
            end
          end
          if env['package.vagrantfile']
            extra = './_include'
            Dir.mkdir(@tmp_include) unless File.directory?(@tmp_include)
            env[:ui].info('Including user Vagrantfile')
            FileUtils.cp(env['package.vagrantfile'], "#{@tmp_include}/Vagrantfile")
          end

          Dir.chdir(tmp_dir)
          File.write('./metadata.json', metadata_content(config.brand,config.kernel, config.vagrant_cloud_creator, boxshortname))
          File.write('./Vagrantfile', vagrantfile_content(config.brand, config.kernel, datasetpath))
          assemble_box(boxname, extra)
          FileUtils.mv("#{tmp_dir}/#{boxname}", "../#{boxname}")
          FileUtils.rm_rf(tmp_dir)
          env[:ui].info('Box created, You can now add the box: vagrant box add #{boxname} --nameofnewbox')
          @app.call(env)
        end

        def snapshot_create(datasetpath, datetime)
          result = execute(true, "#{@pfexec} zfs snapshot -r #{datasetpath}/boot@vagrant_box#{datetime}")
          puts "pfexec zfs snapshot -r #{datasetpath}/boot@vagrant_box#{datetime}" if result.zero?
          puts "#{@pfexec} zfs snapshot -r #{datasetpath}/boot@vagrant_box#{datetime}"
        end

        def snapshot_delete(datasetpath, datetime)
          result = execute(true, "#{@pfexec} zfs destroy -r -F #{datasetpath}/boot@vagrant_box#{datetime}")
          puts "#{@pfexec} zfs destroy -r #{datasetpath}/boot@vagrant_box#{datetime}" if result.zero?
        end

        def snapshot_send(datasetpath, destination, datetime)
          result = execute(true, "#{@pfexec} zfs send #{datasetpath}/boot@vagrant_box#{datetime} > #{destination}")
          puts "#{@pfexec} zfs send #{datasetpath}/boot@vagrant_box#{datetime} > #{destination}" if result.zero?
        end

        def metadata_content(config.brand, _kernel, config.vagrant_cloud_creator, boxshortname)
          <<-ZONEBOX
          {
            "provider": "zone",
            "format": "zss",
            "brand": "#{config.brand}",
            "url": "https://app.vagrantup.com/#{config.vagrant_cloud_creator}/boxes/#{boxshortname}"
          }
          ZONEBOX
        end

        def vagrantfile_content(brand, _kernel, datasetpath)
          <<-ZONEBOX
          Vagrant.configure('2') do |config|
            config.vm.provider :zone do |zone|
              zone.brand = "#{config.brand}"
              zone.datasetpath = "#{datasetpath}"
            end
          end
          user_vagrantfile = File.expand_path('../_include/Vagrantfile', __FILE__)
          load user_vagrantfile if File.exists?(user_vagrantfile)
          ZONEBOX
        end

        def assemble_box(boxname, extra)
          `tar -cvzEf "#{boxname}" ./metadata.json ./Vagrantfile ./box.zss #{extra}`
        end
      end
    end
  end
end
