class CreateTweetTopics < ActiveRecord::Migration
  def change
    create_table :tweet_topics do |t|
      t.integer :tweet_id
      t.integer :topic_id
      t.timestamps null: false
    end
  end
end
