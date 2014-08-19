class CreateContestCodeProblems < ActiveRecord::Migration
  def change
    create_table :contest_code_problems do |t|
      t.integer :contest_id
      t.integer :code_problem_id

      t.timestamps
    end
  end
end
