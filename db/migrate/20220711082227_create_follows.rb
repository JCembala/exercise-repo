class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.references :follower, null: false, index: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, index: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :follows, [:follower_id, :followed_id], unique: true
  end
end
