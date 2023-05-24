class RemoveUniqueFromSchoolsZipCode < ActiveRecord::Migration[7.0]
  def change
    remove_index "schools", column: [:zip_code], name: "index_schools_on_zip_code"
  end
end
