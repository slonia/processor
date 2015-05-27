class AddFieldsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :text, :text
    add_column :tasks, :url, :text
    add_column :tasks, :input_from, :string
    add_column :tasks, :url_type, :string
  end
end
