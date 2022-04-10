class CreateLetters < ActiveRecord::Migration[6.1]
  def change
    create_table :letters do |t|
      t.references :user, null: false, foreign_key: true
      t.text :message, null: false
      t.integer :dig, null: false, default: 0

      t.timestamps
    end
  end
end
