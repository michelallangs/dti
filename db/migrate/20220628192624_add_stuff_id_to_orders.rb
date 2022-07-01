class AddStuffIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :stuff_id, :integer
  end
end
