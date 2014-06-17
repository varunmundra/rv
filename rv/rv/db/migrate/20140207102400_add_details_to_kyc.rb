class AddDetailsToKyc < ActiveRecord::Migration
  def change
  	add_column :kycs, :part_validation, :string
  	change_column :kycs, :holding_priority, :string
 
  end
end
