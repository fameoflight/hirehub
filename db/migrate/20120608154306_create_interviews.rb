class CreateInterviews < ActiveRecord::Migration
  def change
    create_table :interviews do |t|
      t.integer :user_id
      t.string :candidate_name
      t.string :candidate_email
      t.integer :candidate_id
      t.datetime :start_time
      t.datetime :end_time
      t.string :timezone
      t.text :instruction
      t.string :url_hash

      t.timestamps
    end
  end
end
