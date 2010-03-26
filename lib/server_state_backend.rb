module ServerState
	module Backend
		@@backends = []
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
	end

end

