class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.datetime :send_at, null: false
      t.integer :state, default: 0, null: false
      t.integer :result, default: 2, null: false

      t.timestamps
    end
  end
end
