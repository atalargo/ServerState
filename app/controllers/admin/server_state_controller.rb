class Admin::ServerStateController < Admin::ApplicationController

	def index
		@autorizedIps = ServerStatus.first.ips
		@authorizedIps = nil if(!@authorizedIps.is_a?(Array))
		if request.path_parameters['controller'] != 'admin/server_state'
			render :partial => 'index'
		else
			render 'index_less'
		end
	end

	def add_ip
		newIp = params['ip']
		unless newIp.nil?
			begin
				ServerStatus.add_authorized_ip(ip)
				@addIpResult = 'Ip Rajouté'
			rescue => e
				@addIpResult = 'Error occurs '+e.message
			end
		end
		render :partial => 'add_ip'
	end

	def remove_ip
		unless params['ip'].nil?
			ServerStatus.delete_autorized_ip(ip)
		end
	end
end

