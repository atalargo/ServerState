class CreateServerStatus < ActiveRecord::Migration

	def self.up
		create_table :server_status, :force => true do |t|
			t.boolean :maintenance, :default => false
			t.text :ips, :default => nil
		end
		add_index :server_status,:maintenance

		ServerStatus.create!({:maintenance => true, :ips => []})
	end

	def self.down
		drop_table :server_status
	end
end

