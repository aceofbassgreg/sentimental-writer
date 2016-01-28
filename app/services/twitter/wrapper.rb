require 'yaml'
require 'twitter'

class Twitter::Wrapper

  KEYS = YAML::load(File.open("config/twitter_keys.yml","r"))

  attr_reader :client

  def initialize
    @client = client
  end

  def get(subject)
    client.search(subject)
  end 

  def client
    Twitter::REST::Client.new do |config|
      config.consumer_key    = KEYS["consumer_key"]
      config.consumer_secret = KEYS["consumer_secret"]
    end
  end
end
