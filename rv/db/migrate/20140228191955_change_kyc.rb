class ChangeKyc < ActiveRecord::Migration
  def change
  	add_column :kycs, :nominee_dob, :date
  	add_column :kycs, :nominee_gaurdian, :string
  	add_column :kycs, :nominee_minor_flag, :string
  	add_column :kycs, :nominee_flag, :boolean
  end
end
