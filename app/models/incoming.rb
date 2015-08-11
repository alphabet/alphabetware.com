class Incoming < Message 
	validates :from_phone, presence: true
  
end
