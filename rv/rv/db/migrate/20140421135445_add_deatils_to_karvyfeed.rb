class AddDeatilsToKarvyfeed < ActiveRecord::Migration
   def change
  	 change_column :karvyfeeds, :TRXN_DATE, :string
  	 rename_column :karvyfeeds, :Ck_DIG_NO, :CK_DIG_NO
 
  end
end
