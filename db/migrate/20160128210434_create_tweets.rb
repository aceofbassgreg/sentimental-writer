class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :tweet_id
      t.text :text
      t.string :author_name
      t.string :author_screenname
      t.string :author_location
      t.integer :author_followers
      t.integer :retweet_count
      t.integer :favorite_count
      t.timestamps null: false
    end
  end
end
