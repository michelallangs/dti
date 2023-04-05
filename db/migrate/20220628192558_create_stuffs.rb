class CreateStuffs < ActiveRecord::Migration[7.0]
  def change
    create_table :stuffs do |t|
      t.string :category
      t.string :brand
      t.string :patrimony
      t.string :defaulted, default: "Não"

      t.timestamps
    end
  end
end
