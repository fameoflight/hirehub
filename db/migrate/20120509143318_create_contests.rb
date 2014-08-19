class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :name
      t.integer :user_id
      t.datetime :start_time
      t.time :duration
      t.boolean :reusable, :default => false
      t.boolean :public, :default => false

      t.timestamps
    end
  end
end
