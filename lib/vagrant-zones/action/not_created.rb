# coding: utf-8
require 'log4r'

module VagrantPlugins
	module ProviderZone
		module Action
			class NotCreated
				def initialize(app, _env)
					@app = app
				end

				def call(env)
					env[:ui].info(I18n.t('vagrant_zones.states.not_created'))
					@app.call(env)
				end
			end
		end
	end
end
