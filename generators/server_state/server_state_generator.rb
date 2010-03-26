class ServerStateGenerator < Rails::Generator::Base
	def manifest
		@migration_name = "Create ServerStateMigration"
		@migration_action = "add"
		record do |m|
			m.migration_template 'db/migrate/20090424215700_create_server_status.rb',"db/migrate", :migration_file_name => "create_server_status"
		end
	end
end

