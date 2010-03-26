
namespace :server_state do

	desc "Check maintenance status"
	task :check => :environment do
		if ServerState.is_maintenance?
			print "Maintenance ON\n"
		else
			print "Maintenance OFF\n"
		end
	end

	namespace :set do
		desc "Set maintenance ON"
		task :in => :environment do
			ServerState.set_in_maintenance
		end

		desc "Set maintenance OFF"
		task :out => :environment do
			ServerState.set_out_maintenance
		end
	end

end
