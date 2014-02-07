class AddDetailsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :tax_status, :integer
    add_column :users, :holding_type, :string
  end
end


