class CreateConnpasses < ActiveRecord::Migration[6.1]
  def change
    create_table :connpasses do |t|
      t.references :user, foreign_key: true, unique: true
      t.integer :event_id, nul: false

      t.timestamps
    end
  end
end
