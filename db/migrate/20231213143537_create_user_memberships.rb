class CreateUserMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :user_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.string :license_id
      t.string :github_username

      t.timestamps
    end
  end
end
