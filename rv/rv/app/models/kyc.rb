class Kyc < ActiveRecord::Base

 	validates_presence_of :first_name, :last_name,:pan, :if => :active_or_general?
 	validates_format_of :pan, :with => /\A([A-Za-z]{5}\d{4}[A-Za-z]{1})\Z/i, :if => :active_or_general?
 	validates_presence_of :father_spouse_name,:nationality, :if => :active_or_personal?
	validates_presence_of :c_house_no, :c_street_name, :c_area_name,:c_email,:c_postal_code, :if => :active_or_c_address?
	validates_format_of :c_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :if => :active_or_c_address? 
	validates_format_of :c_postal_code, :with => /\A(\d{6})\Z/i, :if => :active_or_c_address? 
	validates_presence_of :c_mobile, :if => :active_or_c_address? 
	validates_presence_of :p_house_no, :p_street_name, :p_area_name,:p_email,:p_postal_code, :if => :active_or_p_address?
	validates_format_of :p_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :if => :active_or_p_address? 
	validates_format_of :p_postal_code, :with => /\A(\d{6})\Z/i, :if => :active_or_p_address? 
	validates_presence_of :p_mobile, :if => :active_or_p_address? 
	validates_presence_of :nominee_name,:nominee_relation,:nominee_address, :if => :active_or_nominee?	
		

  def active?
    part_validation == 'active'
  end


  def active_or_general?
    part_validation.include?('general') || active?
  end

  def active_or_personal?
    part_validation.include?('personal') || active?
  end

  def active_or_c_address?
    part_validation.include?('c_address') || active?
  end

  def active_or_p_address?
    part_validation.include?('p_address') || active?
  end

  def active_or_nominee?
    part_validation.include?('nominee') || active?
  end


end
