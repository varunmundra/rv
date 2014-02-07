class Kyc < ActiveRecord::Base

   	validates_presence_of :first_name, :last_name, :if => :active_or_personal?
	validates_presence_of :c_house_no, :if => :active_or_c_address?
	validates_presence_of :p_house_no, :if => :active_or_p_address?
	validates_presence_of :nominee_name, :if => :active_or_nominee?	
		


  def active?
    part_validation == 'active'
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
