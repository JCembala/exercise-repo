class AddApiKeyBidxToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.text :api_key_ciphertext
      t.string :api_key_bidx
      t.index :api_key_bidx, unique: true
    end
  end
end
