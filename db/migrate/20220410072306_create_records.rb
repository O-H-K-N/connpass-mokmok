class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :category, null: false, default: 0
      t.string :title, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
