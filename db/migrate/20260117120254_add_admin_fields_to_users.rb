class AddAdminFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :is_admin, :boolean, default: false, null: false
    add_column :users, :suspended_at, :datetime
  end
end
