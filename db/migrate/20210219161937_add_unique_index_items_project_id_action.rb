class AddUniqueIndexItemsProjectIdAction < ActiveRecord::Migration
  def change
    add_index :items, [:project_id, :action], unique: true
  end
end
