class AddLetterStatusToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :letter_status, :integer, default: 0
  end
end
