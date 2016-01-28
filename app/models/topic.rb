class Topic < ActiveRecord::Base
  has_many :tweet_topics
  has_many :tweets, through: :tweet_topics
end
