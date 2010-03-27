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

				def save
					@@mcache.write(@@active_status_key, @@c)
				end
				def self.save!
					save
				end

				def add_authorized_ip(ip)
					@@c[:ips].push(ip)
					save
				end

				def delete_authorized_ip(ip)
					@@c[:ips].delete_if{|iprecord| iprecord == ip}
					save
				end

				def ips
					return @@c[:ips]
				end

				def maintenance
					return @@c[:maintenance]
				end

				def maintenance=(m)
					@@c[:maintenance] = m
				end
			end
		end
	end
end
