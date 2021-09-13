# frozen_string_literal: true

require '
module VagrantPlugins
  module ProviderZone
      module Command
        # This is used to create zfs snapshots the zone
        class CreateSnapshots < Vagrant.plugin('2', :command)
          def execute
            options = {}       
            opts = OptionParser.new do |o|
              o.banner = 'Usage: vagrant zone zfssnapshot list [options]'
              o.on('--dataset SNAPSHOTPATH', 'Specify snapshot path') do |p|
                options[:dataset] = p
              end
              o.on('--snapshot_name @SNAPSHOTNAME', 'Specify snapshot name') do |p|
                options[:snapshot_name] = p
              end
            end

            argv = parse_options(opts)
            return unless argv
            if argv.length > 0
              @env.ui.info(opts.help)
              return
            end

            if options[:dataset].nil?
              @env.ui.info(opts.help)
              return
            end
            if options[:snapshot_name].nil?
              time = Time.new
              dash = "-"
              colon = ":"


              datetime = time.year.to_s + dash + time.month.to_s + dash + time.day.to_s + dash + time.hour.to_s + colon + time.min.to_s + colon + time.sec.to_s
              
              options[:snapshot_name] = datetime
            end

            with_target_vms(argv, provider: :zone ) do |machine|
                driver  = machine.provider.driver
                driver.zfs(machine, @env.ui, 'create', options[:dataset],  options[:snapshot_name] )
              end
          end
        end
      end
   end
end