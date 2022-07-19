class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :requester
      t.integer :order_school
      t.string :spot
      t.text :defect
      t.string :backup, default: "Não"
      t.text :performed_service
      t.text :obs
      t.integer :removal_technician
      t.integer :maintenance_technician
      t.integer :updated_by
      t.date :start_date
      t.date :end_date
      t.string :status, default: "Em aberto"

      t.timestamps
    end
  end
end
