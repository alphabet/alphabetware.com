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
		logger.info("fetching #{base_url}")
		request = Cloudsight::Request.send(locale: 'en', url: media_url)
		Cloudsight::Response.retrieve(request['token']) do |response|
			@response_text = response['name'] #if response['status']=='completed'
		end
		@response_text
	end

	def fetch(uri_str, limit = 10)
		# You should choose better exception.
		raise ArgumentError, 'HTTP redirect too deep' if limit == 0
		response = Net::HTTP.get_response(URI(uri_str))
		case response
		when Net::HTTPSuccess then
			@location.nil? ? uri_str : @location 
		when Net::HTTPRedirection then
			@location = response['location']
			warn "redirected to #{@location}"
			fetch(@location, limit - 1)
		else
			puts 'did something else'
			response
		end
	end

end
