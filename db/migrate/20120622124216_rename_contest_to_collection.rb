class RenameContestToCollection < ActiveRecord::Migration
  def change
  	rename_table :contest_code_problems, :collection_code_problems
  	rename_table :contest_problems, :collection_problems
  	rename_table :contests, :collections

  	rename_column :collection_code_problems, :contest_id, :collection_id
  	rename_column :collection_problems, :contest_id, :collection_id
  	rename_column :invites, :contest_id, :collection_id
  end
end
