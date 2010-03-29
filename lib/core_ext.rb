
ActionController::Base.class_eval do

	prepend_before_filter :maintenance_check
	append_after_filter ServerState::Filter

	protected
	def maintenance_check
		if ServerState.check_maintenance(request.remote_ip)
			respond_to do|format| #82.66.87.202
				format.html {redirect_maintenance}
				format.xml {redirect_maintenance}
				format.js {render :js => "window.location = '"+relative_url_root+"/maintenance.html';", :status => 503}
			end
		end
	end

	def redirect_maintenance
#  		head "HTTP/1.1 503 temporarily overloaded", :location => request.protocol+request.host+relative_url_root+'/maintenance.html'
		redirect_to(relative_url_root+'/maintenance.html', :status => 503)
# 		render  :text => '', :location => request.protocol+request.host+relative_url_root+'/maintenance.html', :status => 503
	end

	def render_with_exception(options = nil, deprececated_status = nil, &block)
		exception = options.delete(:exception) if options
		RAILS_DEFAULT_LOGGER.debug("RAISED EXCEPTION")
		if exception.is_a(ServerState::Backend::BackendHandler)
			redirect_maintenance
		end

	end
end

require File.dirname(__FILE__)+'/../app/helpers/server_state_helper'
Admin::ApplicationController.class_eval do
	helper ServerStateHelper
end

Admin::ApplicationController.helper(ServerStateHelper)


