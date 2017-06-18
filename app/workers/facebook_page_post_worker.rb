class FacebookPagePostWorker
  include Sidekiq::Worker

  # Function: Publishes post on page feed with #{name} of the missing person,
  # #{url} of the missing person details and #{reporter}, i.e contact no of
  # person who registered the alert. #{user} is FB ID of the person who is
  # registering the complaint
  # Reporter contains contact no of the user
  def perform(name, url, reporter, user)
    body = {
      "link": url,
      "message": "Amber Alert! #{name} was reported missing. If found, please contact #{reporter}"
    }
    response = HTTParty.post("https://graph.facebook.com/v2.8/776919939153733/feed?access_token=#{Rails.application.secrets.MY_APP_ACCESS_TOKEN}", body: body)
    puts "Response: #{response.code} : #{response.body}"

    if response.code == 200
      byebug
      rget = HTTParty.get("https://graph.facebook.com/v2.8/#{JSON.parse(response.body)["id"]}?fields=permalink_url&access_token=#{Rails.application.secrets.MY_APP_ACCESS_TOKEN}")
      puts "Response: #{rget.code} : #{rget.body}"
      if rget.code == 200
        MessengerSuccessfulRegistrationNotifyWorker.perform_async(user, "Thank you! We will send an Amber Alert in Mumbai City shortly. You can also share our post about it which is published here: #{JSON.parse(rget.body)["permalink_url"]}")
      end
    else
      MessengerSuccessfulRegistrationNotifyWorker.perform_async(user, "Thank you! An error prevented us from publishing a post. However, you can share the details of the person from this url: #{url}.")
    end
  end
end
