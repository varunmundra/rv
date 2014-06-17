class ChangeKarvyfeeds < ActiveRecord::Migration
   def change
  	 change_column :karvyfeeds, :DOB, :string
  	 change_column :karvyfeeds, :NOM_DOB, :string 
	 change_column :karvyfeeds, :UNITS, :string 
 	 change_column :karvyfeeds, :AMOUNT, :string 
 
  end


end
