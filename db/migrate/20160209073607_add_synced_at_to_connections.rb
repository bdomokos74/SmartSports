class AddSyncedAtToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :synced_at, :datetime
    add_column :connections, :sync_status, :integer, limit:1, default: 0
  end
end
