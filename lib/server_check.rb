module ServerState

	def self.is_maintenance?
		ss = ServerStatus.first
		return false if ss.nil? || ss.maintenance == false
		true
	end

	def self.is_maintenance_for?(ip)
		ss = ServerStatus.first
		return false if( ss.nil? || ss.maintenance == false)
		unless ss.ips.nil?
			return false if !ss.ips.index(ip).nil?
		end
		true
	end

	def self.set_in_maintenance
		ss = ServerStatus.first
		ss = ServerState.new if ss.nil?
		ss.maintenance = true
		begin
			ss.save!
		rescue => e
			RAILS_DEFAULT_LOGGER.info("ERROR ServerState.set_in_maintenance : #{e.message}")
			return false
		end
		return true
	end

	def self.set_out_maintenance
		ss = ServerStatus.first
		ss = ServerState.new if ss.nil?
		ss.maintenance = false
		begin
			ss.save!
		rescue => e
			RAILS_DEFAULT_LOGGER.info("ERROR ServerState.set_out_maintenance : #{e.message}")
			return false
		end
	end

	def self.check_maintenance(remote_ip)
		self.is_maintenance_for?(remote_ip)
	end

	class Filter
		def self.before(controller)
			if ServerState.is_maintenance_for?(controller.request.remote_ip)
				controller.response.redirect_to  controller.relative_url_root+'/maintenance.html', :status=>503
			end
		end

		def self.after(controller)
			if ServerState.is_maintenance?
				body = controller.response.body
				pos = 	if match = body.match(/<\/body>/i)
			               		match.offset(0)[0]
					else
						nil
					end
				unless pos.nil?
					body.insert pos, '<div style="position:fixed;left:10px;top:10px;border:solid 2px red;color:red;font-size:16px;margin:10px;background:white;z-index:100000;">SERVER IN MAINTENANCE</div>'
				end
			end
		end
	end

end

