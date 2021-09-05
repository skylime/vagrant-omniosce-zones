module VagrantPlugins
  module ProviderZone
      module Command
        # This is used to shutdown the guest from inside the guest
        class ShutdownGuest < Vagrant.plugin('2', :command)
          def execute    
            opts = OptionParser.new do |o|
              o.banner = 'Usage: vagrant zone control shutdown [options]'
            end

            argv = parse_options(opts)
            return unless argv
            if argv.length > 0
              @env.ui.info(opts.help)
              return
            end

            ## Wait for VM up
            with_target_vms(argv, provider: :zone ) do |machine|
                machine.action('shutdown')
            end
          end
        end
      end
   end
end