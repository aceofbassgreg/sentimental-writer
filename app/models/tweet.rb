class Tweet < ActiveRecord::Base
  has_many :tweet_hashtags
  has_many :hashtags, through: :tweet_hashtags
  has_many :tweet_topics
  has_many :topics, through: :tweet_topics
  has_many :references
  has_many :people, through: :references

  validates_uniqueness_of :id_from_twitter
end
