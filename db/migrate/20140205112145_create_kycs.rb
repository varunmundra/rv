class CreateKycs < ActiveRecord::Migration
  def change
    create_table :kycs do |t|
	    t.integer :user_id
		t.integer :holding_priority
	    t.string :first_name
	  	t.string :last_name
	  	t.string :father_spouse_name
	  	t.string :gender
	  	t.string :marital_status
	  	t.date :date_of_birth
	  	t.string :nationality
	  	t.string :residence_status
	  	t.string :pan
	  	t.string :proof_of_identity
		t.string :c_house_no
		t.string :c_street_name
		t.string :c_area_name
	 	t.string :c_city_town_village
	  	t.string :c_state
	  	t.string :c_country
	  	t.string :c_postal_code
	  	t.string :c_landline
	  	t.string :c_mobile
	  	t.string :c_email
	  	t.string :c_proof_of_address
	  	t.boolean :same
		t.string :p_house_no
		t.string :p_street_name
		t.string :p_area_name
	  	t.string :p_city_town_village
	  	t.string :p_state
	  	t.string :p_country
	  	t.string :p_postal_code
	  	t.string :p_landline
	  	t.string :p_mobile
	  	t.string :p_email
	  	t.string :p_proof_of_address
	  	t.float :annual_income
	  	t.string :occupation
	  	t.string :pep_status
		t.string :nominee_name
		t.string :nominee_relation
		t.string :nominee_address
	

      t.timestamps
    end
  end
end
