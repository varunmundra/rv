class StaticPagesController < ApplicationController
  def home
  	if user_signed_in?
  		@kyc_exist = Kyc.find_by_user_id(current_user.id)
  		@banks = Bank.find(:all, :conditions => ["user_id = ? ",current_user.id])
    
  	end
  end

  def about
  end

  def products
  end
end
