class AddMessageTypeToMessages < ActiveRecord::Migration[6.1]
  def down 
    remove_column :messages, :message_type
    remove_column :messages, :sent_at
  end

	def up
    add_column :messages, :message_type, :string
    add_column :messages, :sent_at, :timestamp
		say "Updating class of Incoming and Outgoing messages"
	  Message.where('to_phone <> 16462334264').all.collect{|m|m.message_type = 'Outgoing';m.save}
	  Message.where(:to_phone => 16462334264).collect{|m|m.message_type = 'Incoming';m.save}
	end
end
