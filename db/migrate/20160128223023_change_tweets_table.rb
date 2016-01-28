class ChangeTweetsTable < ActiveRecord::Migration
  def change
    rename_column :tweets, :tweet_id, :id_from_twitter
    change_column :tweets, :id_from_twitter, :string
  end
end
