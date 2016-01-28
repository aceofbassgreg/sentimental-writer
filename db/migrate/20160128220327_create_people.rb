class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first
      t.string :last
      t.timestamps null: false
    end
  end
end