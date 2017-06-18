class FacebookPagePostWorker
  include Sidekiq::Worker

  def perform(name, url, reporter)
    body = {
      "link": url,
      "message": "Amber Alert! #{name} was reported missing. If found, please contact #{reporter}"
    }
    response = HTTParty.post("https://graph.facebook.com/v2.8/776919939153733/feed?access_token=#{Rails.application.secrets.MY_APP_ACCESS_TOKEN}", body: body)
    puts "Response: #{response.code} : #{response.body}"
  end
end
