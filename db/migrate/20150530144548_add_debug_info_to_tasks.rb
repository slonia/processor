class AddDebugInfoToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :debug_info, :text
  end
end
