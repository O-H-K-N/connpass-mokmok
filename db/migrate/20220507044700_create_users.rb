class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :line_id, null: false
      t.string :account
      t.integer :count, default: 10
      t.boolean :flag, default: false

      t.timestamps
    end
  end
end
