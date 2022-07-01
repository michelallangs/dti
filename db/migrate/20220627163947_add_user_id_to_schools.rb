class AddUserIdToSchools < ActiveRecord::Migration[7.0]
  def change
    add_column :schools, :user_id, :integer
  end
end
