class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :user_id
      t.integer :problem_id
      t.text :submission_text
      t.boolean :judged
      t.integer :score, :default => 0
      t.string :lang
      t.string :problem_type
      t.string :status, :default => 'Waiting'
      t.text :compiler_output
      t.decimal :execution_time, :default => 0
      t.integer :submittable_id
      t.string :submittable_type
      t.text :run_output, :default => ''

      t.timestamps
    end
  end
end
