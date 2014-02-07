class KycStepsController < ApplicationController
  include Wicked::Wizard
  steps  :c_address, :p_address, :nominee
  
  def show
  	@kyc = Kyc.find_by_user_id(current_user.id) # incorporate holding priority check for joint users
    render_wizard
  end

  def update
	  @kyc = Kyc.find_by_user_id(current_user.id)
  	  @kyc.part_validation = step.to_s
  	  @kyc.part_validation = 'active' if step == steps.last	
	  @kyc.update_attributes(kyc_params1)
	  render_wizard @kyc
  end

  private
	  def kyc_params1
	    params.require(:kyc).permit(:user_id,:holding_priority,:first_name,:last_name,:father_spouse_name,:gender,:marital_status,:date_of_birth,:nationality,:residence_status,
	    	:pan,:proof_of_identity,:c_house_no,:c_street_name,:c_area_name,:c_city_town_village,:c_state,:c_country,:c_postal_code,:c_landline,:c_mobile,:c_email,:c_proof_of_address,
	    	:same,:p_house_no,:p_street_name,:p_area_name,:p_city_town_village,:p_state,:p_country,:p_postal_code,:p_landline,:p_mobile,:p_email,:p_proof_of_address,:annual_income,
	    	:occupation,:pep_status,:nominee_name,:nominee_relation,:nominee_address,:part_validation)
	    

	  end

end
