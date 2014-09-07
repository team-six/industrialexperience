class CreateEmployeeStatuses < ActiveRecord::Migration
  def change
    create_table :employee_statuses do |t|
      t.string :es_type

      t.timestamps
    end
  end
end
