class CreateInviteSubmissions < ActiveRecord::Migration
  def change
    create_table :invite_submissions do |t|
      t.integer :invite_id
      t.integer :problem_id
      t.integer :submission_id

      t.timestamps
    end
  end
end
