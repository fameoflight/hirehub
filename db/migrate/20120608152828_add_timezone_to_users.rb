class AddTimezoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :timezone, :string, :default => 'Eastern Time (US & Canada)'
  end
end
