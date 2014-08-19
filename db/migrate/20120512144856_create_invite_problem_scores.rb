class CreateInviteProblemScores < ActiveRecord::Migration
  def change
    create_table :invite_problem_scores do |t|
      t.integer :invite_id
      t.integer :problem_id
      t.integer :score, :default => 0
      t.string :problem_type, :default => 'text'

      t.timestamps
    end
  end
end
