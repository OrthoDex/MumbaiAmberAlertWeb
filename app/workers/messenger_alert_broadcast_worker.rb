class MessengerAlertBroadcastWorker
  include Sidekiq::Worker

  # Send Broadcast Alert to all subscribers. Retrieve Subscriber list from Redis.
  def perform(url, name, reporter)
    redis = Redis.new(url: ENV["REDISCLOUD_URL"] || 'redis://localhost:6379/14')
    subscriber_list = redis.lrange "subs", 0, -1
    subscriber_list.each do |subscriber|
      MessengerSuccessfulRegistrationNotifyWorker.perform_async(subscriber.to_i, "Amber Alert! #{name} was reported missing. If found, please contact #{reporter}.", url)
    end
  end
end
