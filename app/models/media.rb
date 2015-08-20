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
		self.base_url=url
	end

	def media_url
		self.base_url
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
#		Cloudsight.api_key = CONSUMER_KEY if Cloudsight.api_key.nil?
		Cloudsight.oauth_options = {}
		logger.info "Cloudsight: OAUTH_OPTIONS #{Cloudsight.oauth_options}"
		Cloudsight.oauth_options = { consumer_key: CONSUMER_KEY, consumer_secret: CONSUMER_SECRET} if Cloudsight.oauth_options === {} ||  Cloudsight.oauth_options.nil?
#		Cloudsight.base_url = 'http://posttestserver.com/post.php'

		logger.info "Cloudsight: OAUTH_OPTIONS==={} #{Cloudsight.oauth_options==={}}"
		#		File.open(@filename_path, 'wb') { |file| file.write( (fetch(self.base_url)))}
		request = Cloudsight::Request.send(locale: 'en-US', url: fetch(self.base_url))
		Cloudsight::Response.retrieve(request['token']) do |response|
			@response_text = response['name'] #if response['status']=='completed'
		end
		@response_text
	end

	def fetch(uri_str, limit = 10)
		# You should choose better exception.
		logger.info("### fetch #{limit} #{uri_str}")
		raise ArgumentError, 'HTTP redirect too deep' if limit == 0
		uri = URI.parse(uri_str)
		Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
			request = Net::HTTP::Get.new uri
			response = http.request(request)
		case response
  		when Net::HTTPSuccess then
  			sleep 0.15
  			logger.info "returning with #{@location.nil? ? uri_str : @location }"
				@location.nil? ? uri_str : @location 
  		when Net::HTTPRedirection then
  			@location = response['location']
  			sleep 0.15 
  			warn "redirected to #{@location}"
  			fetch(@location, limit - 1)
  		else
  			puts 'did something else'
  			response
  		end
		end
	end

end
