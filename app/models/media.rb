class Media < ActiveRecord::Base
	validates :description, presence: true
	belongs_to :incoming, :foreign_key => 'message_id'
	before_validation :identification_complete, if: "newly_described?"
	before_save :described_at_timestamp

	def described_at_timestamp
		described_at = Time.now
	end

	#@p = URI::Parser.new
	#self.uri = @p.split(self.incoming.media_url)[5]
	#self.base_url = self.incoming.media_url

	def media_url=(url)
		self.base_url=fetch(url)
	end

	def media_url
		puts "base media_url is #{self.base_url.to_s}"
		fetch(self.base_url)
	end

	def newly_described?
		logger.info "checking if new #{self.described_at.nil?}"
		self.described_at.nil? && self.description.nil?
	end

	def identification_complete
		puts 'completing identification'
		self.description = self.cloudsight
	end

	def cloudsight
#		Cloudsight.api_key = CONSUMER_KEY
		Cloudsight.oauth_options = { consumer_key: CONSUMER_KEY, consumer_secret: CONSUMER_SECRET}
		logger.info("fetching #{media_url}")
		request = Cloudsight::Request.send(locale: 'en', url: media_url)
		Cloudsight::Response.retrieve(request['token']) do |response|
			@response_text = response['name'] #if response['status']=='completed'
		end
		@response_text
	end

	def fetch(uri_str, limit = 10)
		# You should choose better exception.
		raise ArgumentError, 'HTTP redirect too deep' if limit == 0
		uri = URI.parse(uri_str)
		twilio = URI.parse('https://api.twilio.com')
		http = Net::HTTP.new(twilio.host, twilio.port)
		http.use_ssl = true if http.port == 443

		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request)
		
		case response
		when Net::HTTPSuccess then
			@location.nil? ? twilio.scheme + '://' + twilio.host + uri.request_uri : @location 
		when Net::HTTPRedirection then
			@location = response['location']
			sleep 0.5 
			warn "redirected to #{@location}"
			fetch(@location, limit - 1)
		else
			puts 'did something else'
			response
		end
	end

end
