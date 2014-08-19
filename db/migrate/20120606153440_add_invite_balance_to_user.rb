class AddInviteBalanceToUser < ActiveRecord::Migration
  def change
    add_column :users, :invite_balance, :integer, :default => 50
  end
end
