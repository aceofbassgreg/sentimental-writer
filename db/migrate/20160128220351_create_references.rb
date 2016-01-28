class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.integer :tweet_id
      t.integer :person_id
      t.timestamps null: false
    end
  end
end
