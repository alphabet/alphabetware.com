class Message < ActiveRecord::Base
	has_many :medias

	validates :from_phone, presence: true

	def upload
	end

	def cloudsight
	end

	def respond
		client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
		response_attachments = ["http://catza.net/static/photo/20140510tampere/IMG_8488.JPG", "http://catza.net/static/photo/20091010kirkkonummi/IMG_2532.JPG",
													"http://catza.net/static/photo/20110129lahti/SLA_1452.JPG", "http://www.heikkisiltala.com/_data/i/galleries/sessions_sessiot/20150613_cats_macro_jamsa/IMG_0899-me.JPG",
													"http://catza.net/static/photo/20140726helsinki/COOL0252.JPG", "https://upload.wikimedia.org/wikipedia/commons/b/b4/Samoyede_Nauka_2003-07_asb_PICT1895_small.JPG"]
	  replies = ["I agree. ...but I'm not sure what I just agreed to.", "Are you sure?", "I think you might be pulling my leg", "What can I do with that information.", "Hold on, let me see if I can get the answer from SIRI. LOL. SIRI doesn't know either."]

		from_phone = FROM
		to_phone = self.from_phone 
		body = replies[rand(replies.length)] + "\n\nWould you like to us to connect you with someone in your area: i.e., near #{(self.from_city.to_s.strip + ' ' + self.from_state.to_s.strip).strip}"
		media_url = response_attachments[rand(response_attachments.length)] 
		outgoing = client.account.messages.create(:from => from_phone, :to => to_phone, :body => body, :media_url => media_url)

		media = Media.new(:parent_sid => outgoing.sid, :account_sid => outgoing.account_sid)
		message = Message.new(:from_phone => outgoing.from, :to_phone => outgoing.to, :body => outgoing.body, :medias => [media],
													:media_url => media_url, :sms_sid => outgoing.sid, :account_sid => outgoing.account_sid, 
													:twilio_api_version => outgoing.api_version)
		message.save!
	end

end
