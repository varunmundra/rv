class KycsController < ApplicationController


  def update_holding_type
    if params[:commit] == '1'
      current_user.holding_type = '1'
      current_user.tax_status = 1
      current_user.save
      kyc = Kyc.new
      kyc.user_id = current_user.id
      kyc.part_validation = 'new'
      kyc.holding_priority = '1'
      kyc.save 
    end
    if params[:commit] == '2'
      current_user.holding_type = '4'
      current_user.tax_status = 21
      current_user.save
      kyc = Kyc.new
      kyc.user_id = current_user.id
      kyc.part_validation = 'new'
      kyc.holding_priority = '1'
      kyc.save 
    end
    if params[:commit] == '3'
      current_user.holding_type = '5'
      current_user.tax_status = 11
      current_user.save
      kyc = Kyc.new
      kyc.user_id = current_user.id
      kyc.part_validation = 'new'
      kyc.holding_priority = '1'
      kyc.save 
    end
    if params[:commit] == '4'
      current_user.holding_type = '7'
      current_user.tax_status = 2
      current_user.save
      kyc = Kyc.new
      kyc.user_id = current_user.id
      kyc.part_validation = 'new'
      kyc.holding_priority = '1'
      kyc.save 
      kyc = Kyc.new
      kyc.user_id = current_user.id
      kyc.part_validation = 'new'
      kyc.holding_priority = '4'
      kyc.save 
    end
    if params[:commit] == '5'
      current_user.holding_type = '6'
      current_user.tax_status = 3
      current_user.save
      kyc = Kyc.new
      kyc.user_id = current_user.id
      kyc.part_validation = 'new'
      kyc.holding_priority = '1'
      kyc.save 
    end
    if params[:commit] == '6'
      current_user.holding_type = '2'
      current_user.tax_status = 1
      current_user.save
      kyc = Kyc.new
      kyc.user_id = current_user.id
      kyc.part_validation = 'new'
      kyc.holding_priority = '1'
      kyc.save 
      kyc = Kyc.new
      kyc.user_id = current_user.id
      kyc.part_validation = 'new'
      kyc.holding_priority = '2'
      kyc.save 
    end
    if params[:commit] == '7'
      current_user.holding_type = '3'
      current_user.tax_status = 1
      current_user.save
      kyc = Kyc.new
      kyc.user_id = current_user.id
      kyc.part_validation = 'new'
      kyc.holding_priority = '1'
      kyc.save 
      kyc = Kyc.new
      kyc.user_id = current_user.id
      kyc.part_validation = 'new'
      kyc.holding_priority = '2'
      kyc.save
      kyc = Kyc.new
      kyc.user_id = current_user.id
      kyc.part_validation = 'new'
      kyc.holding_priority = '3'
      kyc.save  
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
	    	:occupation,:pep_status,:nominee_name,:nominee_relation,:nominee_address,:nominee_flag,:nominee_dob,:nominee_gaurdian,:part_validation)
	    
 

	  end


end


	