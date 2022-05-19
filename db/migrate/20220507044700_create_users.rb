class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :line_id, null: false
      t.string :account
      t.integer :count, default: 10
      t.integer :prefecture, default: 13
      t.string :word_first
      t.string :word_second
      t.string :word_third
      t.boolean :flag, default: false
      t.boolean :checked, default: false

      t.timestamps
    end
  end
end
