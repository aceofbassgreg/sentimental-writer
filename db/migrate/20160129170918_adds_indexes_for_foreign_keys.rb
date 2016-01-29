class AddsIndexesForForeignKeys < ActiveRecord::Migration
  def change
    add_index :tweet_topics, :tweet_id
    add_index :tweet_topics, :topic_id
    add_index :references, :person_id
    add_index :references, :tweet_id
    add_index :tweet_hashtags, :tweet_id
    add_index :tweet_hashtags, :hashtag_id
  end
end
