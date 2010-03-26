module ServerState
	module Backend

		ServerState::Backend.add_backend('Memcache')
		module Memcache

			class ServerStatus
				@@mcache = ActiveSupport::Cache::MemCacheStore.new

				@@active_status_key = 'server_status_cache_backend_key'


				def self.first
					@@c = @@mcache.fetch(@@active_status_key) do
						{:ips => [], :maintenance => false}
					end
					self
				end

				def self.save
					@@mcache.write(@@active_status_key, @@c)
				end
				def self.save!
					save
				end

				def self.add_authorized_ip(ip)
					@@c[:ips].push(ip)
					save
				end

				def self.delete_authorized_ip(ip)
					@@c[:ips].delete_if{|iprecord| iprecord == ip}
					save
				end

				def self.ips
					return @@c[:ips]
				end

				def self.maintenance
					return @@c[:maintenance]
				end

				def self.maintenance=(m)
					@@c[:maintenance] = m
				end
			end
		end
	end
end
