class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :requester
      t.string :spot
      t.text :defect
      t.boolean :backup
      t.text :performed_service
      t.text :obs
      t.integer :removal_technician
      t.integer :maintenance_technician
      t.date :start_date
      t.date :end_date
      t.string :status, default: "Aberto"

      t.timestamps
    end
  end
end
