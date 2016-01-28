require 'forwardable'

class Twitter::Importer

  extend Forwardable

  delegate [:get] => :wrapper

  extend Forwardable

  attr_reader :wrapper

  def initialize
    @wrapper = Twitter::Wrapper.new
  end

  def load_tweets_for(subject)
    all_tweets_for(subject).each do |tweet|
      store_all_data_from(tweet)
    end
  end

  def all_tweets_for(subject)
    get(subject).attrs.first.last
  end

  def store_all_data_from(tweet_data)
    sentiment_score = Sentimental::Processor.new(tweet_data[:text]).get_score
    tweet_record = store(tweet_data,sentiment_score)

    return unless !!tweet_record.id

    hashtags(tweet_data).each do |hashtag|
      tweet_record.hashtags.create(name: hashtag[:text])
    end

  rescue 
    binding.pry
  end

  def store(tweet,sentiment_score)
    ::Tweet.create(
      id_from_twitter: tweet[:id],
      text: tweet[:text],
      author_name: tweet[:user][:name],
      author_screenname: tweet[:user][:screen_name],
      author_location: tweet[:user][:location],
      author_followers: tweet[:user][:followers_count],
      retweet_count: tweet[:retweet_count],
      favorite_count: tweet[:favorite_count],
      sentiment_score: sentiment_score
      )
  end

  def hashtags(tweet_data)
    tweet_data[:entities][:hashtags]
  end

  def store_tweet_hashtag(tweet_id, hashtag_id)
    TweetHashtag.create(
      tweet_id: tweet_id,
      hashtag_id: hashtag_id
      )
    
  end


end