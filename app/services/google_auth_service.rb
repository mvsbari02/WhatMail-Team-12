module GoogleAuthService
  def initialize(user)
    @user = user
    @client = Google::APIClient.new(application_name: 'WhatMail', application_version: '1.0')
    @client.authorization.client_id = ENV['GOOGLE_CLIENT_ID']
    @client.authorization.client_secret = ENV['GOOGLE_CLIENT_SECRET']
    @client.authorization.access_token = @user.access_token
    @client
  end
  
  def watch_inbox
    service = @client.discovered_api('gmail', 'v1')
    response = @client.execute(
      api_method: service.users.messages.list,
      parameters: {
        userId: 'me',
        q: @user.watch_list,
        maxResults: 1
      }
    )
    message_id = response.data.messages[0].id
    message = @client.execute(
      api_method: service.users.messages.get,
      parameters: {
        userId: 'me',
        id: message_id
      }
    )
    if message.payload.parts.blank?
      body = message.payload.body.data
    else
      body = message.payload.parts[0].body.data
    end
      send_whatsapp_notification(user, body)
    end
    
    private
    
    def send_whatsapp_notification(user, message_body)
      account_sid = ENV['TWILIO_ACCOUNT_SID']
      auth_token = ENV['TWILIO_AUTH_TOKEN']
      @client = Twilio::REST::Client.new(account_sid, auth_token)

      message = @client.messages.create(
                                  from: 'whatsapp:+14155238886',
                                  body: 'Hello there!',
                                  to: user.contact
                                )

          end
end