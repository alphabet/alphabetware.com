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
			media_url: params[:MediaUrl]
		})
		@incoming.medias <<  [Media.new(:parent_sid => @incoming.sms_sid, :media_url => params[:MediaUrl])] if params[:MediaUrl] # should do for each params[:NumMedia]
   
	 	if @incoming.save!
			@outgoing = Outgoing.new(to_phone: @incoming.from_phone, 
															 body: (
																  @incoming.medias.count > 0 ? 
																 	"It looks like you have a #{@incoming.medias.first.description.titleize}." : "We did not receive your attachment. Did you send one?"
																	),
															 to_country: @incoming.from_country,
															 to_city: @incoming.from_city,
															 to_zip: @incoming.to_zip
															)
			@outgoing.save!
      render xml: @incoming, status: :created
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
