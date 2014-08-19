class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :name
      t.text :statement
      t.string :output
      t.integer :user_id
      t.boolean :reusable, :default => true
      t.integer :score, :default => 3

      t.timestamps
    end
  end
end
