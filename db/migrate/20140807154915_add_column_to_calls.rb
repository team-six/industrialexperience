class AddColumnToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :call_duration, :integer
  end
end
