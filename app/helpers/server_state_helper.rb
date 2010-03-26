module ServerStateHelper

	def server_state_admin
		render( :partial => 'admin/server_state/index', :local =>{ 'authorizedIps' => ServerStatus.first.ips})
	end
end

