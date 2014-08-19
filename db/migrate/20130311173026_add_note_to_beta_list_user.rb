class AddNoteToBetaListUser < ActiveRecord::Migration
  def change
    add_column :beta_list_users, :note, :text
  end
end
