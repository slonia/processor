class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :data_type
      t.string :input
      t.string :output

      t.timestamps null: false
    end
  end
end
