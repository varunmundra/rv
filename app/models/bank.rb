class Bank < ActiveRecord::Base
	validates_presence_of :name_of_bank ,:account_num , :account_type ,:mode_of_holding,
	 :first_holder,:branch_address, :city, :ifsc_code, :micr_code,:sip_validity, :sip_upper_limit

	 

	 
end
