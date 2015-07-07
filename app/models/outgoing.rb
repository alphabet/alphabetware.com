class Outgoing < Message 
	validates :body, presence: true
	def send_message
		client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN 
		if self.valid?
			outgoing = client.account.messages.create(:from => FROM, 
																								:to => to_phone, 
																								:body => body)
			self.sms_sid = outgoing.sid
			self.account_sid = outgoing.account_sid 
			self.twilio_api_version = outgoing.api_version
		end	
		self.save!
	end
end

