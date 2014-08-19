class CreateBetaLists < ActiveRecord::Migration
  def change
    create_table :beta_list_users do |t|
        t.string :name, :null => false
        t.string :email, :null => false
        t.boolean :email_sent
        t.datetime :accepted
        t.string :token
        t.timestamps
    end

    add_index :beta_list_users, :email,  :unique => true
    add_index :beta_list_users, :token,  :unique => true
  end
end
