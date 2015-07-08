class Outgoing < Message 
	validates :body, presence: true
	validate :from_cannot_be_same_as_to
	def send_message_and_save
		self.from_phone = FROM
		client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN 
		if self.valid?
			outgoing = client.account.messages.create(:from => from_phone, 
																								:to => to_phone, 
																								:body => body)
			self.sms_sid = outgoing.sid
			self.account_sid = outgoing.account_sid 
			self.twilio_api_version = outgoing.api_version
		end
		debugger
		self.save!
	end


	def from_cannot_be_same_as_to
		if to_phone == FROM
			errors.add(:to_phone, "Message to is the same as #{FROM}")
		end
		if to_phone == from_phone 
			errors.add(:from_phone, "Message to is the same as Message from (#{from_phone})")
		end
	end

end

