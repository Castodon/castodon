class AddIndexToUserMemberships < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_index :user_memberships, :license_id, unique: true , algorithm: :concurrently
    add_index :user_memberships, :github_username, unique: true, algorithm: :concurrently

  end
end
