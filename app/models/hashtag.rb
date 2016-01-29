class Hashtag < ActiveRecord::Base
  has_many :tweet_hashtags
  has_many :tweets, through: :tweet_hashtags

  scope :excluding, ->(hashtag) { where.not(id: hashtag.id) }
end
