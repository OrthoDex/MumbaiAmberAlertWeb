class MessengerSuccessfulRegistrationNotifyWorker
  include Sidekiq::Worker

  def perform(sender, text, details_url, photo_url=nil)
    # Send confirmation through Fb Messenger
    body = {
      "recipient":{
        "id": sender
      },
      "message": {
        "attachment": {
          "type": "template",
          "payload": {
            "template_type": "button",
            "text": text,
            "buttons": [
              {
                "type": "web_url",
                "url": details_url,
                "title": "Show Post",
                "webview_height_ratio": "tall"
              }
            ]
          }
        }
      }
    }

    url = "https://graph.facebook.com/v2.6/me/messages?access_token=#{Rails.application.secrets.MY_APP_ACCESS_TOKEN}"
    response = HTTParty.post(url, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
    puts "Messenger response: #{response.code} : #{response.body}"

    if !photo_url.nil?
      puts "Sending Photo of missing person."
      body = {
        "recipient":{
          "id": sender
        },
        "message": {
          "attachment": {
            "type": "image",
            "payload": {
              "url": photo_url
            }
          }
        }
      }
      response = HTTParty.post(url, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
      puts "Messenger response: #{response.code} : #{response.body}"
    end
  end
end
