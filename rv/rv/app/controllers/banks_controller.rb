class BanksController < ApplicationController

	def new
		@bank = Bank.new
	end

	def create
	    
	    @bank = Bank.new(bank_params)
	    @bank.user_id = current_user.id
	  	if @bank.name_of_bank == "Kotak Bank"
	   		@bank.bankid_pg = "162"
	   	end
		if @bank.name_of_bank == "Allahabad Bank"
		 @bank.bankid_pg = "ALB"
	    end
		if @bank.name_of_bank == "Bank of India"
		 @bank.bankid_pg = "BOI"
	    end
		if @bank.name_of_bank == "State Bank of Hyderabad"
		 @bank.bankid_pg = "SBH"
		end
		if @bank.name_of_bank == "State Bank of India"
		 @bank.bankid_pg = "SBI"
		end
		if @bank.name_of_bank == "State Bank of Bikaner & Jaipur"
		 @bank.bankid_pg = "SBJ"
		end
		if @bank.name_of_bank == "State Bank of Mysore"
		 @bank.bankid_pg = "SBM"
	    end
		if @bank.name_of_bank == "State Bank of Patiala"
		 @bank.bankid_pg = "SBP"
	    end
		if @bank.name_of_bank == "State Bank of Travancore"
		 @bank.bankid_pg = "SBT"
	    end
		if @bank.name_of_bank == "City Union Bank"
		 @bank.bankid_pg = "CUB"
	    end
		if @bank.name_of_bank == "HDFC Bank"
		 @bank.bankid_pg = "HDF"
		end
		if @bank.name_of_bank == "Tamilnad Mercantile Bank Ltd."
		 @bank.bankid_pg = "TMB"
	    end
		if @bank.name_of_bank == "Axis Bank"
		 @bank.bankid_pg = "UTI"
		end
		if @bank.name_of_bank == "Andhra Bank" 
		 @bank.bankid_pg = "ADB"
		end
		if @bank.name_of_bank == "Bank of Baroda - Corporate Banking"
		 @bank.bankid_pg = "BBC"
		end
		if @bank.name_of_bank == "Bank of Bahrain and Kuwait"
		 @bank.bankid_pg = "BBK"
		end
		if @bank.name_of_bank == "Bank of Baroda - Retail Banking"
		 @bank.bankid_pg = "BBR"
		end
		if @bank.name_of_bank == "Bank of Maharashtra"
		 @bank.bankid_pg = "BOM"
		end
		if @bank.name_of_bank == "Central Bank of India"
		 @bank.bankid_pg = "CBI"
		end
		if @bank.name_of_bank == "Canara Bank"
		 @bank.bankid_pg = "CNB"
		end
		if @bank.name_of_bank == "Punjab National Bank - Corporate Banking"
		 @bank.bankid_pg = "CPN"
		end
		if @bank.name_of_bank == "Corporation Bank"
		 @bank.bankid_pg = "CRP"
		end
		if @bank.name_of_bank == "Catholic Syrian Bank"
		 @bank.bankid_pg = "CSB"
		end
		if @bank.name_of_bank == "Deutsche Bank"
		 @bank.bankid_pg = "DBK"
		end
		if @bank.name_of_bank == "Development Credit Bank"
		 @bank.bankid_pg = "DCB"
		end
		if @bank.name_of_bank == "Dhanlakshmi Bank"
		 @bank.bankid_pg = "DLB"
		end
		if @bank.name_of_bank == "Federal Bank"
		 @bank.bankid_pg = "FBK"
		end
		if @bank.name_of_bank == "IDBI Bank"
		 @bank.bankid_pg = "IDB"
		end
		if @bank.name_of_bank == "IndusInd Bank"
		 @bank.bankid_pg = "IDS"
		end
		if @bank.name_of_bank == "Indian Bank"
		 @bank.bankid_pg = "INB"
		end
		if @bank.name_of_bank == "ING Vysya Bank"
		 @bank.bankid_pg = "ING"
		end
		if @bank.name_of_bank == "Indian Overseas Bank"
		 @bank.bankid_pg = "IOB"
		end
		if @bank.name_of_bank == "Jammu & Kashmir Bank"
		 @bank.bankid_pg = "JKB"
		end
		if @bank.name_of_bank == "Karnataka Bank Ltd"
		 @bank.bankid_pg = "KBL"
		end
		if @bank.name_of_bank == "Karur Vysya Bank"
		 @bank.bankid_pg = "KVB"
		end
		if @bank.name_of_bank == "Laxmi Vilas Bank - Corporate Net Banking"
		 @bank.bankid_pg = "LVC"
		end
		if @bank.name_of_bank == "Laxmi Vilas Bank - Retail Net Banking"
		 @bank.bankid_pg = "LVR"
		end
		if @bank.name_of_bank == "Oriental Bank of Commerce"
		 @bank.bankid_pg = "OBC"
		end
		if @bank.name_of_bank == "Punjab National Bank - Retail Banking"
		 @bank.bankid_pg = "PNB"
		end
		if @bank.name_of_bank == "Punjab & Sind Bank"
		 @bank.bankid_pg = "PSB"
		end
		if @bank.name_of_bank == "South Indian Bank"
		 @bank.bankid_pg = "SIB"
		end
		if @bank.name_of_bank == "Shamrao Vitthal Co-operative Bank"
		 @bank.bankid_pg = "SVC"
		end
		if @bank.name_of_bank == "Syndicate Bank"
		 @bank.bankid_pg = "SYD"
		end
		if @bank.name_of_bank == "Union Bank of India"
		 @bank.bankid_pg = "UBI"
		end
		if @bank.name_of_bank == "UCO Bank"
		 @bank.bankid_pg = "UCO"
		end
		if @bank.name_of_bank == "United Bank of India"
		 @bank.bankid_pg = "UNI"
		end
		if @bank.name_of_bank == "Vijaya Bank" 
		 @bank.bankid_pg = "VJB"
		end
		if @bank.name_of_bank == "Yes Bank Ltd"
		 @bank.bankid_pg = "YBK"
		end
		if @bank.name_of_bank == "ICICI Bank"
		 @bank.bankid_pg = "ICI"
		end
		@bank.sip_mandate_status = 1

		if @bank.save	
	      current_user.bank_status = 1
	      current_user.save
	      redirect_to home_path
	    else
	      render :action => 'new'
	    end
	      
  	end



  	def show
  	   @bank = Bank.find(params[:id])
  	end


  	def edit
    	@bank = Bank.find(params[:id])
  	end
  
    def update
	    @bank = Bank.find(params[:id])
	    if @bank.update_attributes(bank_params)
	      
	      redirect_to home_path
	    else
	      render :action => 'edit'
	    end
	end
		

  private
	  def bank_params
	    params.require(:bank).permit(:name_of_bank ,:account_num , :account_type ,:mode_of_holding,
	 :first_holder,:second_holder,:branch_address, :city, :ifsc_code, :micr_code,
	  :sip_mandate_status, :sip_validity, :sip_upper_limit, :umrn,:reason, :bankid_pg)
	    

	  end


	


end



	
	


