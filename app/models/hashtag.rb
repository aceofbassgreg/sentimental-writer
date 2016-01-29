class Hashtag < ActiveRecord::Base
  has_many :tweet_hashtags, dependent: :destroy
  has_many :tweets, through: :tweet_hashtags

  scope :excluding, ->(hashtags) { where.not(id: hashtags.map(&:id)) }
end
