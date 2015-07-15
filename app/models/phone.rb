class Phone < ActiveRecord::Base 
	has_many :messages
	validates :phone_number, presence: true
end

