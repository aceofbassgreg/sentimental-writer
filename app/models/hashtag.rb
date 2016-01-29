class Hashtag < ActiveRecord::Base
  has_many :tweet_hashtags
  has_many :tweets, through: :tweet_hashtags

  scope :excluding, ->(hashtags) { where.not(id: hashtags.map(&:id)) }
end
