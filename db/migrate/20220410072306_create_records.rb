class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.references :user, null: false, foreign_key: true
      t.string :theme, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
