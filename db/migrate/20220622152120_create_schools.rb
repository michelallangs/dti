class CreateSchools < ActiveRecord::Migration[7.0]
  def change
    create_table :schools do |t|
      t.string :segment
      t.string :name, null: false
      t.string :address, null: false
      t.integer :address_number, null: false
      t.string :district, null: false
      t.string :zip_code, null: false
      t.string :phone, null: false

      t.timestamps
    end

    add_index :schools, :name, unique: true
    add_index :schools, :phone, unique: true
    add_index :schools, :zip_code, unique: true
  end
end
