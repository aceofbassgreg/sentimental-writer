class TweetTopic < ActiveRecord::Base
  belongs_to :tweet
  belongs_to :topic
end
