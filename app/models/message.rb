class Message < ActiveRecord::Base
  has_many :medias
	
	validates :from_phone, :body, presence: true

	def upload
	end

	def cloudsight
	end

	def respond
		client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN

		from_phone = FROM
		to_phone = self.from_phone 
		body = "Hey, Monkey party at 6PM near #{(self.from_city.to_s.titleize + ' ' + self.from_state.to_s).strip}. Bring Bananas!"
		media_url = "https://upload.wikimedia.org/wikipedia/commons/b/b4/Samoyede_Nauka_2003-07_asb_PICT1895_small.JPG"
		outgoing = client.account.messages.create(:from => from_phone, :to => to_phone, :body => body, :media_url => media_url)

		media = Media.new(:parent_sid => outgoing.sid, :account_sid => outgoing.account_sid)
		message = Message.new(:from_phone => outgoing.from, :to_phone => outgoing.to, :body => outgoing.body, :medias => [media], 
								:sms_sid => outgoing.sid, :account_sid => outgoing.account_sid, :twilio_api_version => outgoing.api_version)
		message.save!
	end

end
