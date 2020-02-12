begin
	require "vagrant"
rescue LoadError
	raise "The Vagrant Zone plugin must be run within Vagrant."
end

module VagrantPlugins
	module ProviderZone
		class Plugin < Vagrant.plugin('2')
			name "zone"
			description <<-DESC
			This plugin allows vagrant to manage lx-branded zones or native zones on
			OmniOSce or any other illumos based distribution
			DESC

			config(:zone, :provider) do
				require_relative "config"
				Config
			end

			provider(:zone) do
				require_relative "provider"
				Provider
			end

			# This sets up our log level to be whatever VAGRANT_LOG is.
			def self.setup_logging
				require 'log4r'

				level = nil
				begin
					level = Log4r.const_get(ENV['VAGRANT_LOG'].upcase)
				rescue NameError
					# This means that the logging constant wasn't found,
					# which is fine. We just keep `level` as `nil`. But
					# we tell the user.
					level = nil
				end

				# Some constants, such as "true" resolve to booleans, so the
				# above error checking doesn't catch it. This will check to make
				# sure that the log level is an integer, as Log4r requires.
				level = nil if !level.is_a?(Integer)

				# Set the logging level on all "vagrant" namespaced
				# logs as long as we have a valid level.
				if level
					logger = Log4r::Logger.new('vagrant_zone')
					logger.outputters = Log4r::Outputter.stderr
					logger.level = level
					logger = nil
				end
			end

			# Setup logging and i18n before any autoloading loads other classes
			# with logging configured as this prevents inheritance of the log level
			# from the parent logger.
			setup_logging
		end
	end
end
