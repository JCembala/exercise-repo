class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content, limit: 160
      t.references :user, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
