class CreateConnpasses < ActiveRecord::Migration[6.1]
  def change
    create_table :connpasses do |t|
      t.string :account

      t.timestamps
    end
  end
end
