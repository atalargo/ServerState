module ServerState
	module Backend

		ServerState::Backend.add_backend('Filebk')
		module Filebk
			class ServerStatus

				attr_accessor :maintenance, :ips
				@@file_maintenance = RAILS_ROOT+'/tmp/maintenance.lock'
				@@config_base_yml = RAILS_ROOT+'/config/server_state_ips.yml'
				@@config_dyna_yml = RAILS_ROOT+'/tmp/server_state_ips.yml'
				@@instance = nil

				protected
				def initialize
					@maintenance = (File.exist?(@@file_maintenance))
					@ips = []
					if File.exist?(@@config_base_yml)
						@ips = YAML.load(File.open(@@config_base_yml))
					end
					if File.exist?(@@config_dyna_yml)
						t = YAML.load(File.open(@@config_dyna_yml))
						@ips += t if t.is_a?(Array)
					end
				end

				public
				def self.first(*args)
					@@instance = ServerStatus.new if @@instance.nil?
					return @@instance
				end

				def save
					@ips = [] if @ips.nil?
					File.open(@@config_dyna_yml, 'w') {|f| f << @ips.to_yaml }
					if @maintenance
						`touch #{@@file_maintenance}`
					else
						File.delete((@@file_maintenance)) if (File.exist?(@@file_maintenance))
					end
				end

				def save!
					save
				end

				def add_authorized_ip(ip)
					@ips = [] if @ips.nil?
					@ips.delete_if{|iprecord| iprecord == ip}
					@ips.push(ip)
					save
				end

				def delete_authorized_ip(ip)
					@ips.delete_if{|iprecord| iprecord == ip}
					save
				end


			end
		end
	end
end
