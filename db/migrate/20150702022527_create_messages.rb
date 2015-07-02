class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
			t.integer :to_phone, :limit => 11
			t.integer :from_phone, :limit => 11
			t.string :body
			t.string :to_country
		  t.string :to_state
		  t.string :to_city
			t.string :to_zip
		  t.string :num_media	
			t.string :from_country
			t.string :from_state
			t.string :from_city
			t.string :from_zip
			t.string :sms_sid
			t.string :account_sid
			t.string :twilio_api_version

      #"ToCountry"=>"US", "ToState"=>"NY", "SmsMessageSid"=>"SM17e6664304cc97594fa32092d2850b23", "NumMedia"=>"0", "ToCity"=>"NEW YORK", "FromZip"=>"10006", "SmsSid"=>"SM17e6664304cc97594fa32092d2850b23", "FromState"=>"NY", "SmsStatus"=>"received", "FromCity"=>"NEW YORK", "Body"=>"flabber", "FromCountry"=>"US", "To"=>"ENV['TWILIO_FROM_NUMBER']", "ToZip"=>"10011", "MessageSid"=>"SM17e6664304cc97594fa32092d2850b23", "AccountSid"=>"ENV['TWILIO_ACCOUNT_SID']", "From"=>"+12123493533", "ApiVersion"=>"2010-04-01"
			
			
			t.timestamps null: false
    end
  end
end
