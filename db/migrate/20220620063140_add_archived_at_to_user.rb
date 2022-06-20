class AddArchivedAtToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :archived_at, :datetime
  end
end
