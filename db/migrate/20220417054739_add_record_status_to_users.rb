class AddRecordStatusToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :record_status, :integer, default: 0
  end
end
