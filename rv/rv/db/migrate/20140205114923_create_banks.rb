class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|

      t.integer :user_id
	  t.string :name_of_bank
	  t.string :account_num
	  t.string :account_type
	  t.string :mode_of_holding
	  t.string :first_holder
	  t.string :second_holder
	  t.string :branch_address
	  t.string :city
	  t.string :ifsc_code
	  t.string :micr_code
	  t.integer :sip_mandate_status
	  t.integer :sip_validity
	  t.float :sip_upper_limit
	  t.string :umrn
	  t.string :reason
	  t.string :bankid_pg
		

      t.timestamps
    end
  end
end
