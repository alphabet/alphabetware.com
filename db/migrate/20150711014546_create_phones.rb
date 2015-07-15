class CreatePhones < ActiveRecord::Migration
  def up
	  add_column :messages, :phone_id, :integer	
    create_table :phones do |t|
      t.integer :phone_number, :limit => 8
    end
		puts "saved #{FROM}" if Phone.new(:phone_number => FROM).save! #save system phone
	  phones = Message.select(:to_phone).distinct.collect{|p|p.to_phone} - [FROM]
		#byebug
		Incoming.group(:from_phone).each do |incoming|
			say "Migrating incoming #{incoming.from_phone.to_s}"
			p = Phone.new(:phone_number => incoming.from_phone)
			if p.save!
				puts "saved incoming #{incoming.from_phone}"
			  Incoming.where(:from_phone => incoming.from_phone).update_all(:phone_id => p.id)
				incoming.save!
			end		
		end
	end

	def down
		drop_table :phones
		remove_column :messages, :phone_id
	end

end
