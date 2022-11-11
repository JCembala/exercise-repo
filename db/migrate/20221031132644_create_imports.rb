class CreateImports < ActiveRecord::Migration[7.0]
  def change
    create_table :imports do |t|
      t.string :aasm_state
      t.string :error_message

      t.timestamps
    end
  end
end
