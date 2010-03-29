module ServerState
	module Backend
		@@backends = []
		@@handlers = []
		BackendHandler = nil
		def Backend.available_backends
			if @@backends.empty?
				Dir.entries('./backend/').each do |bckd|
					require('./backend/'+bckd) if /\.rb$/ =~ bckd
				end
			end
			@@backends
		end
		def Backend.add_backend(b_name)
			@@backends.push(b_name)
		end

		def Backend.use_backend(b_name)
			require(File.dirname(__FILE__)+'/backend/backend_'+b_name.downcase)
			@@bck = b_name
		end

		def Backend.backend
			@@bck
		end

		def Backend.set_handler_for(e)
# 			BackendHandler = e
		end

		def Backend.handler_for(e)
		RAILS_DEFAULT_LOGGER.debug('raised error '+e.to_s)
			e.is_a?(BackendHandler)
		end

		def ActiveRecord.rescue_with_handler(e)
			if ServerState::Backend.handler_for(e)
				redirect_maintenance
			end
		end
	end

end

