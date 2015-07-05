class Message < ActiveRecord::Base
	has_many :medias
	validates :from_phone, presence: true
	validates_with MessageValidator, fields: [:from_phone, :to_phone]

	def upload
	end

	def cloudsight
		Cloudsight.api_key= CONSUMER_KEY
		request = Cloudsight::Request.send(locale: 'en', url: self.media_url)
		Cloudsight::Response.retrieve(request['token']) do |response|
			media = self.medias.first
			media.description = response['name'] if response['status']=='completed'
			media.save!
		end
	end

	def identify(message)
		logger.info "Sending Identification!"
		client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
		from_phone = FROM
		to_phone = self.to_phone == FROM ? self.from_phone : self.to_phone
		body = "It looks like you have a #{message}."
		outgoing = client.account.messages.create(:from => from_phone, :to => to_phone, :body => body)

		message = Message.new(:from_phone => outgoing.from, :to_phone => outgoing.to, :body => outgoing.body,
													:sms_sid => outgoing.sid, :account_sid => outgoing.account_sid, 
													:twilio_api_version => outgoing.api_version)
		message.save!
	end

	def respond(reply: nil)
		client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
		response_attachments = ["http://catza.net/static/photo/20140510tampere/IMG_8488.JPG", "http://catza.net/static/photo/20091010kirkkonummi/IMG_2532.JPG",
													"http://catza.net/static/photo/20110129lahti/SLA_1452.JPG", "http://www.heikkisiltala.com/_data/i/galleries/sessions_sessiot/20150613_cats_macro_jamsa/IMG_0899-me.JPG",
													"http://catza.net/static/photo/20140726helsinki/COOL0252.JPG", "https://upload.wikimedia.org/wikipedia/commons/b/b4/Samoyede_Nauka_2003-07_asb_PICT1895_small.JPG"]
		replies = ["I agree. ...but I'm not sure what I just agreed to.", "Are you sure?", "I think you might be pulling my leg", "What can I do with that information.", "Hold on, let me see if I can get the answer from SIRI. LOL. SIRI doesn't know either."]

		from_phone = FROM
		to_phone = self.from_phone 

		if reply.nil? 
			body = replies[rand(replies.length)] + "\n\nWould you like to us to connect you with someone in your area: i.e., near #{(self.from_city.to_s.strip + ' ' + self.from_state.to_s.strip).strip}"
			media_url = response_attachments[rand(response_attachments.length)] 
		else
			body = "This looks like a #{reply}. How would you like to proceed?"
		end


		media = Media.new(:parent_sid => outgoing.sid, :account_sid => outgoing.account_sid)
		message = Message.new(:from_phone => from_phone, :to_phone => to_phone, :body => body, :medias => [media])
		if message.valid?
			outgoing = client.account.messages.create(:from => from_phone, :to => to_phone, 
																							:body => body, :media_url => media_url)
		  messagge.media_url = media_url
	   	message.sms_sid = outgoing.sid
	 	  message.account_sid = outgoing.account_sid 
		  message.twilio_api_version = outgoing.api_version
		  message.save!
		end
	end

end
