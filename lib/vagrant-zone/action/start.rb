require "log4r"

module VagrantPlugins
	module ProviderZone
		module Action
			class Start
				def initialize(app, env)
					@logger = Log4r::Logger.new("vagrant_zone::action::import")
					@app = app
				end

				def call(env)
					@machine = env[:machine]
					@driver  = @machine.provider.driver

					@driver.boot(@machine, env[:ui])
					@app.call(env)
				end
			end
		end
	end
end
