class CreateRecordCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :record_categories do |t|
      t.references :record, foreign_key: true
      t.references :category, foreign_key: true
      t.timestamps
    end
    add_index :record_categories, [:record_id, :category_id], unique: true
  end
end
