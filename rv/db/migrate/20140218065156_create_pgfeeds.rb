class CreatePgfeeds < ActiveRecord::Migration
  def change
    create_table :pgfeeds do |t|

      t.integer :user_id
      t.string :order_number
      t.float :amount
      t.text :msgtopg
      t.text :msgfrompg	
      t.string :error_status
	    t.string :error_desc
	    t.string :auth_status
      t.string :payement_status 
      t.string :transaction_ref_no   
      t.timestamps
    end
  end
end
