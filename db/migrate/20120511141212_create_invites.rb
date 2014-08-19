class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :user_id
      t.integer :contest_id
      t.string :candidate_email
      t.string :url_hash
      t.string :candidate_name
      t.datetime :start_time
      t.integer :score, :default => 0
      t.boolean :agree, :default => false
      t.integer :candidate_id
      t.text :instruction
      t.boolean :user_finish, :default => false
      t.datetime :finish_time

      t.timestamps
    end
  end
end
