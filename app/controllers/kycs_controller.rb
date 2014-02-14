class KycsController < ApplicationController


  def update_holding_type
  	if params[:holding_type]
	  	current_user.holding_type = params[:holding_type]
	  	current_user.save
	
	  	for i in 0..(current_user.holding_type.to_i-1)
	   		kyc = Kyc.new
	  		kyc.user_id = current_user.id
	  		kyc.holding_priority = (i+1).to_s
	  		kyc.part_validation = 'new'
	  		kyc.save
		end
  	end
	

  end


  def new
	@kyc = Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ? ",current_user.id, params[:priority]])
  	session[:priority] = params[:priority]
  end



  def create

    @kyc = Kyc.new(kyc_params)
    @kyc.part_validation = 'general'
    if @kyc.save		
      current_user.kyc_status = 1 #partial kyc done
      current_user.save
      redirect_to kyc_steps_path
    else
      render :new
    end
  end

  def update
  	   @kyc = Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ? ",current_user.id, session[:priority]])
  	   @kyc.part_validation = 'general'
       if @kyc.update_attributes(kyc_params)
       		redirect_to kyc_steps_path
       else
      		render :new
       
       end  
  end

  private
	  def kyc_params
	    params.require(:kyc).permit(:user_id,:holding_priority,:first_name,:last_name,:father_spouse_name,:gender,:marital_status,:date_of_birth,:nationality,:residence_status,
	    	:pan,:proof_of_identity,:c_house_no,:c_street_name,:c_area_name,:c_city_town_village,:c_state,:c_country,:c_postal_code,:c_landline,:c_mobile,:c_email,:c_proof_of_address,
	    	:same,:p_house_no,:p_street_name,:p_area_name,:p_city_town_village,:p_state,:p_country,:p_postal_code,:p_landline,:p_mobile,:p_email,:p_proof_of_address,:annual_income,
	    	:occupation,:pep_status,:nominee_name,:nominee_relation,:nominee_address,:part_validation)
	    

	  end


end


	