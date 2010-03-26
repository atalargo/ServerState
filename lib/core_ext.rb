
ActionController::Base.class_eval do
	
	prepend_before_filter :maintenance_check
	append_after_filter ServerState::Filter

	protected
	def maintenance_check
		redirect_to('/test/maintenance.html', :status=>503) if(ServerState.check_maintenance(request.remote_ip))
	end

end

require File.dirname(__FILE__)+'/../app/helpers/server_state_helper'
Admin::ApplicationController.class_eval do 
	helper ServerStateHelper
end

Admin::ApplicationController.helper(ServerStateHelper)


