class AddSchoolIdToStuffs < ActiveRecord::Migration[7.0]
  def change
    add_column :stuffs, :school_id, :integer
  end
end
