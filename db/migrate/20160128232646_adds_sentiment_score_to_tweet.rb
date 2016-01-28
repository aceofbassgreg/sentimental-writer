class AddsSentimentScoreToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :sentiment_score, :float
  end
end
