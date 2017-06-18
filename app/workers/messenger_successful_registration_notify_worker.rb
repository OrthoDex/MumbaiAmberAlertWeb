class MessengerSuccessfulRegistrationNotifyWorker
  include Sidekiq::Worker
  
  def perform(sender, text)
    # Send confirmation through Fb Messenger
    body = {
      recipient: {
        id: sender
      },
      message: {
        text: text
      }
    }

    url = "https://graph.facebook.com/v2.6/me/messages?access_token=#{Rails.application.secrets.MY_APP_ACCESS_TOKEN}"
    response = HTTParty.post(url, body: body)
    puts "Messenger response: #{response.code} : #{response.body}"
  end
end
