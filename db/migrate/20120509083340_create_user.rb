class CreateUser < ActiveRecord::Migration
  def up
	create_table(:users) do |t|
	end
  end

  def down
	drop_table :users
  end
end
