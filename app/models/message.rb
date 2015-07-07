class Message < ActiveRecord::Base
	has_many :medias
	self.inheritance_column = :message_type
	def self.message_types
		%w(Incoming Outgoing)
	end

	validates :from_phone, presence: true
	validates_with MessageValidator, fields: [:from_phone, :to_phone]

end

