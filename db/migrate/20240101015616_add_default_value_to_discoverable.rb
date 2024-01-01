class AddDefaultValueToDiscoverable < ActiveRecord::Migration[7.1]
  def change
    change_column_default :accounts, :discoverable, true
  end
end