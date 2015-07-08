class Outgoing < Message 
	validates :body, presence: true
	validate :from_cannot_be_same_as_to
	before_validation :set_from_phone
	before_save :send_twilio_message

	def set_from_phone
		self.from_phone = FROM
	end

	def send_twilio_message
		client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN 
		if self.valid?
			outgoing = client.account.messages.create(:from => from_phone, 
																								:to => to_phone, 
																								:body => body)
			self.sms_sid = outgoing.sid
			self.account_sid = outgoing.account_sid 
			self.twilio_api_version = outgoing.api_version
			self.sent_at = Time.now
		end
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

