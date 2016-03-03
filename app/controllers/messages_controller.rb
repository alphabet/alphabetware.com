class MessagesController < ApplicationController

	before_action :set_message, only: [:show, :update, :destroy]

	# GET /messages
	# GET /messages.json
	def index
		@messages = Message.all

		render json: @messages
	end

	# GET /messages/1
	# GET /messages/1.json
	def show
		render json: @message
	end

	# POST /messages
	# POST /messages.json
	def create
		params = request.params
		@incoming= Incoming.new({
			to_phone: params[:To],
			from_phone: params[:From], 
			body: params[:Body],
			from_country: params[:FromCountry],
			from_state: params[:FromState],
			from_city: params[:FromCity],
			from_zip: params[:FromZip],
			sms_sid: params[:SmsSid],
			account_sid: params[:AccountSid],
			twilio_api_version: params[:ApiVersion],
			media_url: (params[:MediaUrl].nil? ? params[:MediaUrl0] : params[:MediaUrl] )
		})

		@incoming.medias <<  Media.new(:parent_sid => @incoming.sms_sid, :media_url => @incoming.media_url) unless @incoming.media_url.nil? # should do for each params[:NumMedia]

		if @incoming.save!
		  
      # TOKEN AUTH FOR CREATING CHANNELS: alohabet	gui.weinmann	ENV['SLACK_TOKEN']
      # TODO: when a user posts a message, create a channel for that users SMS number
      
		  # post message in slack
		  slack_url = 'ENV['SLACK_WEBHOOK_URL']'
		  slack_payload = {channel: "#general", username: @incoming.from_phone.to_s + " - #{@incoming.from_city}", text: @incoming.body,  icon_emoji: ":telephone_receiver:"}
		  # post the message to slack
		  slack = Typhoeus.post(slack_url, body: slack_payload.to_json)
		  
		  @incoming.medias.map do |media| # post the images and descriptions to slack as well
        slack_payload = {channel: "#general", 
          username: "alohabet-image", 
          text: "<a href='#{media.media_url}'>#{media.description.titleize}</a>",
          icon_emoji: ":octocat:"}
  		  slack = Typhoeus.post(slack_url, body: slack_payload.to_json)		    
	    end
	    
			reg = Regexp.new(/[A-HJ-NPR-Z\d]{8}[\dX][A-HJ-NPR-Z\d]{2}\d{6}/, Regexp::IGNORECASE) # matches vins since 1980
			vin = @incoming.body.scan(reg) # returns an empty array if not match

			if vin.first
				# now lets make an EDMUNDS api call
				# https://api.edmunds.com/api/vehicle/v2/vins/1B7MF3361XJ503719?fmt=json&api_key=s4qcbst9p2atathagmb8d379
				request = Typhoeus::Request.new(
					"https://api.edmunds.com/api/vehicle/v2/vins/#{vin.first}",
					method: :GET,
						body: "body",
						params: { fmt: "json", api_key: ENV['EDMUNDS_KEY'] },
						headers: { Accept: "application/json" }
				)
				response = request.run
				json = JSON.parse(response.body)

				@body = (response.success? ? "It looks like you have a #{json['years'][0]['year']} #{json['make']['name']} #{json['model']['name']} making #{json['engine']['horsepower']} horsepower." : "Unable to identify vin #{vin.first}")
			else

        now = Time.zone.now
        puts "->>>>>>>>>>>>>>>>>>>>>> #{now}"

        availability1_start = (Time.new now.year, now.month, now.day, 14, 30, 0).in_time_zone # 9:30am
        availability1_end = (Time.new now.year, now.month, now.day, 22, 45, 0).in_time_zone #4:45pm
        puts "availability1 --> #{(availability1_start..availability1_end)}"

        availability2_start = (Time.new now.year, now.month, now.day, 1, 59, 0).in_time_zone + 86400 # 8:59pm
        availability2_end =   (Time.new now.year, now.month, now.day, 4, 0, 0).in_time_zone  + 86400 #11pm
        puts "availability2 --> #{(availability2_start..availability2_end)}"

        available = (availability1_start..availability1_end).cover?(now) || (availability2_start..availability2_end).cover?(now)

				if @body.nil? && @incoming.medias.length > 0
						@body = "It looks like you have a #{@incoming.medias.first.description.titleize}." 
				else
				  # core logic
				  reg = Regexp.new(/\#\w+/) # match a hashtag
      		@hashtag = @incoming.body.scan(reg)[0]
      		@hashtag.to_s.slice!(0) # returns an empty array if not match
      		puts ">>>>>>>>>>>>>>>>> hashtag: #{@hashtag}"
      		
      		# check if it's business hours!
      		puts "--------> availabile: #{available}"
			    
				  if !(available)
				    @body = "Sorry the "
				    @body = @hashtag ? "#{@body} #{@hashtag.capitalize} " : "#{@body} Concierge"
				    @body = @body + " team is out studying. We're staffed by real people with lives! Please try between 9:30am and 4:45pm Eastern Standard Time."
			    else
			      @body = "One moment while we locate a concierge to answer your question"
            @body = @body + " about #{@hashtag.capitalize.pluralize}" if @hashtag
			      # start parsing hash tags, connect to an aiml or slack
		      end
				end
			end

			# CREATE AN OUTGOING MESSAGE	
			@outgoing = Outgoing.new(to_phone: @incoming.from_phone, 
															 body: @body,
															 to_country: @incoming.from_country,
															 to_city: @incoming.from_city,
															 to_zip: @incoming.to_zip
															)
			@outgoing.save!
			
			slack_payload = {channel: "#general", username: "alohabet-outgoing", text: @outgoing.body,  icon_emoji: ":ghost:"}
			slack = Typhoeus.post(slack_url, body: slack_payload.to_json)
		  
			render xml: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response></Response>", status: :created
		else
			render xml: @incoming.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /messages/1
	# PATCH/PUT /messages/1.json
	def update
		@message = Message.find(params[:id])

		if @message.update(message_params)
			head :no_content
		else
			render json: @message.errors, status: :unprocessable_entity
		end
	end

	# DELETE /messages/1
	# DELETE /messages/1.json
	def destroy
		@message.destroy

		head :no_content
	end

	private

	def set_message
		@message = Message.find(params[:id])
	end

	def message_params
		params[:message]
	end
end
