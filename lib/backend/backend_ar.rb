module ServerState
	module Backend

		ServerState::Backend.add_backend('Ar')
		ServerState::Backend.set_handler_for(ActiveRecord::ConnectionNotEstablished)
		BackendHandler = ActiveRecord::ConnectionNotEstablished
		module Ar
			class ServerStatus < ActiveRecord::Base
				set_table_name :server_status
				serialize :ips, Array

				@@active_status_key = 'active_status_cache_key'

				def self.first(*args)
					begin
					return super
					ret = if ActionController::Base.cache_configured?
						cac = Rails.cache.read(@@active_status_key)
						if cac.nil?
							r = self.find(:first)
						ActionController::Base.cache @@active_status_key, self
						#	Rails.cache.write(@@active_status_key, r)
							cac = r
						end
						cac
					else
						self.find(:first)
					end
					ret
					rescue => e
						RAILS_DEFAULT_LOGGER.debug(e.message)
						throw e
					end
				end

				def save
					super
					reload(self.id)
			#		autocache
				end

				def add_authorized_ip(ip)
					self.ips = [] if self.ips.nil?
					self.ips.push(ip)
					save!
				end

				def delete_authorized_ip(ip)
					self.ips.delete_if{|iprecord| iprecord == ip}
					save
				end

				protected
				def autocache
					if ActionController::Base.cache_configured?
						ActionController::Base.cache @@active_status_key, self
					end
				end


			end
		end
	end
end
