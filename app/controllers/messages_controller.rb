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
		
		
    reg = Regexp.new(/[A-HJ-NPR-Z\d]{8}[\dX][A-HJ-NPR-Z\d]{2}\d{6}/, Regexp::IGNORECASE) # matches vins since 1980
    vin = @incoming.body.scan(reg) # returns an empty array if not match

	  if vin.first
	      # now lets make an EDMUNDS api call
	      # https://api.edmunds.com/api/vehicle/v2/vins/1B7MF3361XJ503719?fmt=json&api_key=s4qcbst9p2atathagmb8d379
	      request = Typhoeus::Request.new(
          "https://api.edmunds.com/api/vehicle/v2/vins/#{vin.first}",
          method: :GET,
          body: "this is a request body",
          params: { fmt: "json", api_key: ENV['EDMUNDS_KEY'] },
          headers: { Accept: "application/json" }
        )
        response = request.run
        json = JSON.parse(response.body)
        @body = "It looks like you have a #{json['years'][0]['year']} #{json['make']['name']} #{json['model']['name']} making #{json['engine']['horsepower']} horsepower."
    else
				puts "this much media attachment: #{@incoming.medias.length.to_s}"
        if @body.nil?
					@body = @incoming.medias.length > 0 ? 
			 	"It looks like you have a #{@incoming.medias.first.description.titleize}." : "Could you please take a picture of an object and send it to me?"
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
