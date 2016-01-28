class CreateTweetHashtags < ActiveRecord::Migration
  def change
    create_table :tweet_hashtags do |t|
      t.integer :tweet_id
      t.integer :hashtag_id
      t.timestamps null: false
    end
  end
end
