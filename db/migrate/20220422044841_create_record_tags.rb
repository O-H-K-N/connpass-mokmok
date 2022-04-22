class CreateRecordTags < ActiveRecord::Migration[6.1]
  def change
    create_table :record_tags do |t|
      t.references :record, foreign_key: true
      t.references :tag, foreign_key: true
      t.timestamps
    end
    add_index :record_tags, [:record_id, :tag_id], unique: true
  end
end
