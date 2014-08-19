class CreateContestProblems < ActiveRecord::Migration
  def change
    create_table :contest_problems do |t|
      t.integer :contest_id
      t.integer :problem_id

      t.timestamps
    end
  end
end
