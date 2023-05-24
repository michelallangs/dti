class RemoveUniqueFromSchoolsPhone < ActiveRecord::Migration[7.0]
  def change
    remove_index "schools", column: [:phone], name: "index_schools_on_phone"
  end
end
