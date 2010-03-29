class Admin::ServerStateController < Admin::ApplicationController

	def index
		get_ips
		unless flash['addIpResult'].nil?
			@addIpResult = flash['addIpResult']
			@addIpResultError = flash['addIpResultError'] if !@addIpResult
		end
		if request.path_parameters['controller'] != 'admin/server_state'
			render :partial => 'index'
		else
			render 'index_less', :layout => false
		end
	end

	def add_ip
		newIp = params[:newIp]
		if newIp !~ /^(\d{1,3}\.){3}\d{1,3}$/
			@addIpResult = false
			@addIpResultError = I18n.t :bad_format_ip, :scope => :server_state
		else
			unless newIp.nil?
				begin
					ServerStatus.first.add_authorized_ip(newIp)
					@addIpResult = true
				rescue => e
					@addIpResult = false
					@addIpResultError = e.message
				end
			end
		end
		if request.xhr?
			get_ips
			render :partial => 'list_ips', :layout => false
		else
			flash['addIpResult'] = @addIpResult
			flash['addIpResultError'] = @addIpResultError if !@addIpResult
			redirect_to :action => 'index'
		end
	end

	def remove_ip
		unless params[:ip].nil?
			begin
				ServerStatus.first.delete_authorized_ip(params[:ip])
				@addIpResult = true
			rescue => e
				@addIpResult = false
				@addIpResultError = e.message
			end
		end
		if request.xhr?
			get_ips
			render :partial => 'list_ips', :layout => false
		else
			flash['addIpResult'] = @addIpResult
			flash['addIpResultError'] = @addIpResultError if !@addIpResult
			redirect_to :action => 'index'
		end
	end

	def set_in
		ServerState.set_in_maintenance
		redirect_to :action => 'index'
	end

	def set_out
		ServerState.set_out_maintenance
		redirect_to :action => 'index'
	end


	protected
	def get_ips
		@authorizedIps = ServerStatus.first.ips
		@authorizedIps = nil if(!@authorizedIps.is_a?(Array))
	end
end

if defined?(PhusionPassenger)
	Admin::ServerStateController.class_eval do
		def passenger_restart
			`touch #{Rails.root}/tmp/restart.txt`
			render :update do |page|
				page.replace_html 'passenger_return', 'Passenger restarted'
				page.show 'passenger_return'
				page.visual_effect :highlight, 'passenger_return'
				page.delay(10) do
					page.visual_effect :fade, 'passenger_return'
				end
			end
		end

		def passenger_memory
			stat = `passenger-memory-stats`
			render :update do |page|
				page.replace_html 'passenger_memory_stat', stat.gsub(/\[\d*m/, '')
			end
		end
	end
end