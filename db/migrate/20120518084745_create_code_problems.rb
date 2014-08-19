class CreateCodeProblems < ActiveRecord::Migration
  def change
    create_table :code_problems do |t|
      t.string :name
      t.text :statement
      t.string :input
      t.string :output
      t.integer :score, :default => 3
      t.integer :user_id
      t.integer :timeout, :default => 3
      t.string :sample_input, :default => ""
      t.string :sample_output, :default => ""

      t.timestamps
    end
  end
end
