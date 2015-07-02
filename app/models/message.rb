class Message < ActiveRecord::Base
	ACCOUNT_SID= ENV['TWILIO_ACCOUNT_SID']
	AUTH_TOKEN = ENV['TWILIO_AUTH_TOKEN']
	FROM = ENV['TWILIO_FROM_NUMBER'] # Your Twilio number

	validates :from_phone, :body, presence: true

	def respond(sid)
		client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
	  sender = Message.where(sms_message_sid: sid).order(:updated_at).last	

		client.account.messages.create(
			:from => FROM,
			:to => sender.from_phone, 
			:body => "Hey, Monkey party at 6PM near #{(sender.from_city.to_s.titleize + ' ' + sender.from_state.to_s).strip}. Bring Bananas!",
			:media_url => "https://upload.wikimedia.org/wikipedia/commons/b/b4/Samoyede_Nauka_2003-07_asb_PICT1895_small.JPG"
		)
	end

end
