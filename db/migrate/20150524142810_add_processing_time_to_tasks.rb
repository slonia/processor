class AddProcessingTimeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :processing_time, :decimal
  end
end
