class TransactionsController < ApplicationController
	
	def transact
		if params[:switch]
			session[:switch_holding_id] = params[:holding_ids].first
			redirect_to switch_transactions_path
		elsif params[:buy]
			@a = 1
			fund_ids = []
			params[:holding_ids].each do |h|
				holding = Holding.find_by_id(h)
				fund_ids << holding.fund_id
			end
			@funds = Fund.find(fund_ids)
			@banks = Bank.find(:all, :conditions => ["user_id = ?  ",current_user.id,])	
		else
			@a = 0
			@holdings = Holding.find(params[:holding_ids])
			@banks = Bank.find(:all, :conditions => ["user_id = ?  ",current_user.id,])
		end

	end

	def investment
		@funds = Fund.find(params[:fund_ids])
		@banks = Bank.find(:all, :conditions => ["user_id = ?  ",current_user.id])

  	   
	end

	def edit_individual
		if params[:destroy_button]
			transactions = Transaction.find(params[:transaction_ids])	
			transactions.each do |transaction|
				if transaction.tr_mode == "SIP"
					due_transaction = DueTransaction.find_by_transaction_id(transaction.id)
					due_transaction.destroy
				end
			transaction.destroy
			end
			redirect_to transactions_path
		else
			@transactions = Transaction.find(params[:transaction_ids])	
		end	
	end


	def update_individual
	  	Transaction.update(params[:transactions].keys, params[:transactions].values)
	  	flash[:notice] = "Transactions updated"
	  	redirect_to transactions_path
	end

	def invoice
		params[:transactions].each do |transaction1|
			transaction = Transaction.find_or_create_by(user_id: current_user.id , pg_tr_status: "Invoice", fund_id: transaction1["fund_id"])
			transaction.user_id = current_user.id
			transaction.bank_id = params[:bankid]
			if params[:tr_mode] == "Lumpsum" || "SIP"
				transaction.tr_mode = params[:tr_mode]
			end
			transaction.euin_status = params[:euin]
			transaction.tr_date = DateTime.now.to_date
			transaction.update_attributes(transaction1)
			transaction.tr_id = "%.8d" % transaction.id # same trid for switch in switch out..
			
			if transaction.tr_mode == "Full Redemption"
				holding = Holding.find_by_folio_and_fund_id(transaction.folio_id,transaction.fund_id)
				transaction.units = holding.units
				transaction.amount = nil
				transaction.save
			end
			if transaction.tr_type == "R"
				transaction.pg_tr_status = "PAID"
				transaction.save
			end
			if transaction.tr_mode == "SIP"  
				transaction.sip_installment_count = 0
				transaction.pg_tr_status = "Invoice"
				transaction.sip_registration_no = "SIP-%.8d" % (transaction.id+10000) 
				due_transaction = DueTransaction.find_or_create_by(transaction_id: transaction.id)
				due_transaction.transaction_id = transaction.id
      			due_transaction.due_date = transaction.sip_start_date

      			due_transaction.sip_counter = 1
      			due_transaction.sip_installments = transaction.sip_installments 
      			due_transaction.save
      		else
      			due_transaction = DueTransaction.find_by_transaction_id(transaction.id)
      			if due_transaction
      				due_transaction.destroy
				end
      			transaction.sip_registration_no = nil
			end
			transaction.save
		end	
		redirect_to transactions_path

	end

	def index
		@transactions_invoice = Transaction.find(:all, :conditions => ["user_id = ? AND pg_tr_status = ?  ",current_user.id, "Invoice"])
		@transactions_redeem = Transaction.find(:all, :conditions => ["user_id = ? AND registrar_tr_status = ? AND tr_type = ? ",current_user.id, "Invoice", "R"])
		
		if @transactions_invoice.length> 0 
			if  @transactions_invoice.first.tr_type == "P"
				if @transactions_invoice.first.tr_mode == "SIP" && 
					@sip_lumpsum = 1
				else
					@sip_lumpsum = 0
				end
			end 
		elsif @transactions_redeem.length> 0 
			if @transactions_redeem.first.tr_type == "R"
				@redemption = 1
			end
		else redirect_to funds_path
			
		end
	end

	def switch
		@holding = Holding.find(session[:switch_holding_id])
		@fundsto = Fund.find(:all, :conditions => ["registrar_amc_code = ?",@holding.amc])
		
		
	end
	
	def ru
	end

	def ru2
		@d ='2222222'
		uri = URI.parse("https://www.billdesk.com/pgidsk/pgmerc/RUPVESTMFRedirect.jsp")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		data = "msg=RUPVESTMF|27|1232465646546|2.00|IDB|NA|NA|INR|DIRECT|R|rupvestmf|NA|NA|F|NA|NA|ARN-86572|HDFCMFD-NA-NA-NA|LIQUID|RESIDENT-15425-NA-NA-NA-NA-L-NA-NA|20140422161151-2.00-NA-NA-NA|https://rupeevest.com/transactions/ru|E7ACACE724B9CF20963A984A9AF9B62C4F15995C83032720DA00E905E969CC7C"
		headers = {
			'Referer' => 'https://www.rupeevest.com/transactions/ru'
		}
		#request = Net::HTTP::Post.new(uri.request_uri)
		#request.set_form_data({:msg=>'RUPVESTMF|27|1232465646546|2.00|IDB|NA|NA|INR|DIRECT|R|rupvestmf|NA|NA|F|NA|NA|ARN-86572|HDFCMFD-NA-NA-NA|LIQUID|RESIDENT-15425-NA-NA-NA-NA-L-NA-NA|20140422161151-2.00-NA-NA-NA|https://rupeevest.com/transactions/ru|E7ACACE724B9CF20963A984A9AF9B62C4F15995C83032720DA00E905E969CC7C'})
		#request['HTTP_REFERER'] = 'https://www.rupeevest.com/transactions/ru'
		#response = RestClient.post 'https://www.billdesk.com/pgidsk/pgmerc/RUPVESTMFRedirect.jsp', 'msg=RUPVESTMF|27|1232465646546|2.00|IDB|NA|NA|INR|DIRECT|R|rupvestmf|NA|NA|F|NA|NA|ARN-86572|HDFCMFD-NA-NA-NA|LIQUID|RESIDENT-15425-NA-NA-NA-NA-L-NA-NA|20140422161151-2.00-NA-NA-NA|https://rupeevest.com/transactions/ru|E7ACACE724B9CF20963A984A9AF9B62C4F15995C83032720DA00E905E969CC7C'
  		#response = Net::HTTP.post_form(uri,{:msg=>'RUPVESTMF|27|1232465646546|2.00|IDB|NA|NA|INR|DIRECT|R|rupvestmf|NA|NA|F|NA|NA|ARN-86572|HDFCMFD-NA-NA-NA|LIQUID|RESIDENT-15425-NA-NA-NA-NA-L-NA-NA|20140422161151-2.00-NA-NA-NA|https://rupeevest.com/transactions/ru|E7ACACE724B9CF20963A984A9AF9B62C4F15995C83032720DA00E905E969CC7C'})
  		response = http.post(uri.path,data,headers)
  		@d = response.body
  		@d2 = response.code
  		
  	end

	def ru1
		require 'digest/hmac'
		@transactions_pg = Transaction.find(:all, :conditions => ["user_id = ? AND pg_tr_status = ?  AND tr_mode = ? ",current_user.id, "Invoice", "Lumpsum"])
		
		pgfeed = Pgfeed.new
		pgfeed.user_id = current_user.id
		pgfeed.amount = 0
		i=0
		bankid = 0
		fund_type = ''
		additional_info5a = ['NA','NA','NA','NA']
		additional_info8a = ['NA','NA','NA','NA']
		additional_info9a = ['NA','NA','NA','NA']
		@transactions_pg.each do |transaction|
			bankid = transaction.bank_id
			additional_info5a[i] = Fund.find_by_id(transaction.fund_id).pg_amc_code
			additional_info8a[i] = transaction.amount
			additional_info9a[i] = Fund.find_by_id(transaction.fund_id).pg_scheme_code
			fund_type = Fund.find_by_id(transaction.fund_id).category
			transaction.pg_tr_status = "Prepayement"
			pgfeed.amount = transaction.amount + pgfeed.amount
			transaction.save
			i=i+1
		end
		bank = Bank.find_by_id(bankid)
		kyc = Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ?  ",current_user.id, "1"])
		pgfeed.save
		pgfeed.order_number = pgfeed.id.to_s
		@transactions_pg.each do |transaction|
			transaction.pg_order_number = pgfeed.order_number
			transaction.save
		end
		additional_info5 = "#{additional_info5a[0]}-#{additional_info5a[1]}-#{additional_info5a[2]}-#{additional_info5a[3]}"
		if fund_type == "Debt:Liquid Fund"
			additional_info6 = "LIQUID"
		else
			additional_info6 = "NONLIQUID "
		end
		additional_info7 = kyc.residence_status
		additional_info8 = "#{DateTime.now.strftime("%Y%m%d%H%M%S")}-#{additional_info8a[0]}-#{additional_info8a[1]}-#{additional_info8a[2]}-#{additional_info8a[3]}"
		additional_info9 = "#{additional_info9a[0]}-#{additional_info9a[1]}-#{additional_info9a[2]}-#{additional_info9a[3]}" 
    	additional_info10 = 'NA' #logic for sender SIP No.
	    additional_info11 =  'L' # build logic for SIP
	    additional_info12 = 'NA' # clarify this
	    additional_info7to12 = "#{additional_info7}-#{additional_info9}-#{additional_info10}-#{additional_info11}-#{additional_info12}-NA"
    	msg = "RUPVESTMF|#{pgfeed.order_number}|#{bank.account_num}|#{pgfeed.amount}|#{bank.bankid_pg}|NA|NA|INR|DIRECT|R|rupvestmf|NA|NA|F|NA|#{current_user.pg_user_code}|ARN-86572|#{additional_info5}|#{additional_info6}|#{additional_info7to12}|#{additional_info8}|http://rupeevest.com/transactions/ru"
    	checksumkey = "r4W98wT1jE7E"
    	checksum = Digest::HMAC.hexdigest(msg, checksumkey, Digest::SHA256)
		checksum = checksum.upcase
		@msgtopg = "#{msg}|#{checksum}"
		pgfeed.msgtopg = @msgtopg
		pgfeed.save
		

	end



	def confirmation
		require 'digest/hmac'
	    response = params[:msgpg].split('|')
	    checksumreturn = response[25]
	    checksumkey = "r4W98wT1jE7E"
	    msgfrompg = params[:msgpg].slice(0..-(checksumreturn.length+2))
	    calculated_checksum = Digest::HMAC.hexdigest(msgfrompg, checksumkey, Digest::SHA256)
	    # calculated_checksum = calculated_checksum.upcase
	    if calculated_checksum != checksumreturn
	    	@err = "cheksum not matched"
	    else
	    	pgfeed = Pgfeed.find_by_order_number(response[16]) # for status prepayement also
	    	if pgfeed
	    		pgfeed.msgfrompg = params[:msgpg]
	    		transactions_for_order = Transaction.find(:all, :conditions => ["user_id = ? AND pg_order_number = ?  ",pgfeed.user_id, response[16].to_i])
				pgfeed.auth_status = response[14]
				pgfeed.error_status = response[23]
				pgfeed.error_desc = response[24]
				pgfeed.transaction_ref_no = response[2]
				pgfeed.save
				if pgfeed.auth_status == "0300" 
		            if pgfeed.amount == response[4].to_f
		              transactions_for_order.each do |t|
		                t.pg_transaction_no = pgfeed.transaction_ref_no
		                t.pg_tr_status = 'PAID'
		                t.save

		              end
		            end
		            if pgfeed.amount != response[4].to_f
		              @amt = pgfeed.amount
		              @amt1 = response[4].to_f
		              pgfeed.payement_status = "Amount does not match"
		              pgfeed.save
		            end
	            end
	            if pgfeed.auth_status == "0399" 
	            	pgfeed.payement_status = "Invalid Authentication at Bank"
		            pgfeed.save
		            transactions_for_order.each do |t|
		                t.pg_tr_status = 'FALIURE'
		                t.save
		            end
		        end
	          	if pgfeed.auth_status == "NA"
	          		pgfeed.payement_status = "Invalid Input in Request Message"
		            pgfeed.save
		            transactions_for_order.each do |t|
		                t.pg_tr_status = 'FALIURE'
		                t.save
		            end 	           
	          	end
	          	if pgfeed.auth_status == "0001"
	          		pgfeed.payement_status = "Error at Bill Desk"
		            pgfeed.save
		            transactions_for_order.each do |t|
		                t.pg_tr_status = 'FALIURE'
		                t.save
		            end 	           
	          	end 
	          	if pgfeed.auth_status == "0002" 
	          		pgfeed.payement_status = "BillDesk is waiting for Response from Bank"
		            pgfeed.save
		            transactions_for_order.each do |t|
		                t.pg_tr_status = 'FALIURE'
		                t.save
		            end 	           
	          	end 

	    	end




	    end

	end

	def karvy_upload_feed
		require 'Nokogiri'
		transactions = Transaction.find(:all, :conditions => ["registrar_tr_status = ? AND pg_tr_status = ? AND registrar = ?  ","Invoice", "PAID", "Karvy"])
		transactions.each do |t|
			karvyfeed = Karvyfeed.new
			karvy_data = KarvyData.new
			fund = Fund.find_by_id(t.fund_id)
			bank = Bank.find_by_id(t.bank_id)
			user = User.find_by_id(t.user_id)
			kyc1= Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ? ",user.id, "1"])
			joint_name1 = ''
			joint_name2 = ''
			joint1_pan = ''
			joint2_pan = ''
			joint1_pan_valid = ''
			joint2_pan_valid = ''
			holding_nature = "SI"
			if user.holding_type == "2" 
				kyc2= Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ? ",user.id, "2"])
				joint_name1 = kyc2.first_name+kyc2.last_name
				joint1_pan = kyc2.pan
				holding_nature = "AS"
				joint1_pan_valid = 'Y'
			end
			if user.holding_type == "3"
				kyc2= Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ? ",user.id, "2"])
				joint_name1 = kyc2.first_name+kyc2.last_name
				joint1_pan = kyc2.pan
				holding_nature = "AS"
				joint1_pan_valid = 'Y'
				kyc3= Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ? ",user.id, "3"])
				joint_name3 = kyc3.first_name+kyc3.last_name
				joint2_pan = kyc3.pan
				joint2_pan_valid = 'Y'
			end		
	
			if t.amount
				units= ''
				amount = sprintf('%.2f', t.amount)
			else
				units = t.units
				amount = ''
			end
			gaurdian_name = ''
			gaurdian_pan = ''
			gaurdian_pan_valid = ''
			if user.holding_type == '7'
				kyc4= Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ? ",user.id, "4"])
				gaurdian_name = "#{kyc4.first_name} #{kyc4.last_name}"
				gaurdian_pan = kyc4.pan
				gaurdian_pan_valid = 'Y'
			end
			occupation = OccupationMaster.find_by_description(kyc1.occupation)
			occupation_code = occupation.karvy_code
			state = StateMaster.find_by_description(kyc1.c_state)
			state_code = state.karvy_code
			location = CityMaster.find_by_description(kyc1.c_city_town_village)
			location_code = location.karvy_code
			if t.tr_mode == "SIP"
				sub_tr_type = 'S'
				sip_reg_date = t.sip_start_date
				sip_reg_no = t.sip_registration_no
				no_of_inst = t.sip_installments
				sip_freq = 'OM'
				start_date = t.sip_start_date.strftime("%m-%d-%y")
				end_date = (t.sip_start_date + no_of_inst.months).strftime("%m-%d-%y")
				installment_no = t.sip_installment_count
			else
				sub_tr_type = 'Normal'
				sip_reg_date = ''
				sip_reg_no = ''
				no_of_inst = '' 
				sip_freq = ''
				start_date = ''
				end_date = ''
				installment_no = ''

			end
			if fund.category == "Debt:Liquid Fund"
				pricing = "H"
			else
				pricing = "F"
			end
			nri_sof = ''
			firc_sta = ''
			nri_addl_address1 = ''
			nri_addl_address2 = ''
			nri_addl_address3 = ''
			nri_city = ''
			nri_state = ''
			nri_country = ''
			nri_pincode = ''
			checkflag = ''
			if user.holding_type == '4'
				nri_sof = bank.account_num
				firc_sta = 'Y'
				nri_addl_address1 = kyc1.c_house_no
				nri_addl_address2 = kyc1.c_street_name
				nri_addl_address3 = kyc1.c_area_name
				nri_city = kyc1.c_city_town_village
				nri_state = kyc1.c_state
				nri_country = kyc1.c_country
				nri_pincode = kyc1.c_postal_code
				checkflag = 'Y'
			end
			if user.holding_type == '5'
				nri_sof = bank.account_num
				firc_sta = 'Y'
				nri_addl_address1 = kyc1.c_house_no
				nri_addl_address2 = kyc1.c_street_name
				nri_addl_address3 = kyc1.c_area_name
				nri_city = kyc1.c_city_town_village
				nri_state = kyc1.c_state
				nri_country = kyc1.c_country
				nri_pincode = kyc1.c_postal_code
				checkflag = 'Y'
			end


			if kyc1.nominee_minor_flag == 'Y'
				n_dob = kyc1.nominee_dob
				n_minor_flag = 'Y'
				n_gaurdian = kyc1.nominee_gaurdian
			else
				n_dob = ''
				n_minor_flag = ''
				n_gaurdian = ''
			end

			if kyc1.nominee_flag
				nomination_opted = 'Y'
			else
				nomination_opted = 'N'
			end

			karvyfeed.AMC_CODE = fund.registrar_amc_code
			karvyfeed.BROKE_CD = "ARN-86572"
			#karvyfeed.SBBR_CODE
			karvyfeed.USER_CODE = "Rupeevest"
			karvyfeed.USR_TXN_NO = t.tr_id
			#APPL_NO
			karvyfeed.FOLIO_NO = t.folio_id
			#Ck_DIG_NO
			karvyfeed.TRXN_TYPE = t.tr_type
			karvyfeed.SCH_CODE = fund.registrar_scheme_code
			karvyfeed.FIRST_NAME = kyc1.first_name
			karvyfeed.JONT_NAME1 = joint_name1
			karvyfeed.JONT_NAME2 = joint_name2
			karvyfeed.ADD1 = kyc1.c_house_no
			karvyfeed.ADD2 = kyc1.c_street_name
			karvyfeed.ADD3 = kyc1.c_area_name
			karvyfeed.CITY = kyc1.c_city_town_village
			karvyfeed.PINCODE = kyc1.c_postal_code
			#karvyfeed.PHONE_OFF 
			karvyfeed.MOBILE_NO = kyc1.c_mobile
			karvyfeed.TRXN_DATE = t.created_at.strftime("%m/%d/%Y")
			karvyfeed.TRXN_TIME = t.created_at.strftime("%H:%M:%S")
			karvyfeed.UNITS = units
			karvyfeed.AMOUNT = amount
			if t.tr_mode == "Full Redemption"
			  karvyfeed.CLOS_AC_CH  = 'Y'
			  karvyfeed.UNITS = ''
			  karvyfeed.AMOUNT = ''
			end
			karvyfeed.DOB = kyc1.date_of_birth.strftime("%m-%d-%Y")
			karvyfeed.GUARDIAN = gaurdian_name
			karvyfeed.TAX_NUMBER = kyc1.pan
			#karvyfeed.PHONE_RES
			#karvyfeed.FAX_OFF
			#karvyfeed.FAX_RES
			#karvyfeed.EMAIL
			karvyfeed.ACCT_NO = bank.account_num
			karvyfeed.ACCT_TYPE = bank.account_type
			karvyfeed.BANK_NAME = bank.name_of_bank
			karvyfeed.BR_NAME = bank.branch_address
			karvyfeed.BANK_CITY = bank.city
			karvyfeed.REINV_TAG = t.reinvestment_tag
			karvyfeed.HOLD_NATUR = holding_nature
			karvyfeed.OCC_CODE = occupation_code
			karvyfeed.TAX_STATUS = user.tax_status
			#karvyfeed.REMARKS
			karvyfeed.STATE = state_code
			karvyfeed.PAN_2_HLDR = joint1_pan
			karvyfeed.PAN_3_HLDR = joint2_pan
			karvyfeed.GUARD_PAN = gaurdian_pan
			karvyfeed.LOCATION = location_code
			#karvyfeed.UINNO
			#karvyfeed.FORM6061
			#karvyfeed.FORM6061J1
			#karvyfeed.FORM6061J2
			karvyfeed.PAY_MEC = 'D'
			#karvyfeed.RTGS_CD 
			#karvyfeed.NEFT_CD
			#karvyfeed.MICR_CD
			karvyfeed.DEPBANK = "ICICI BANK" #religare
			karvyfeed.DEP_ACNO = "039305000211"
			karvyfeed.DEP_DATE = t.tr_date.strftime("%m/%d/%y")
			karvyfeed.DEP_RFNo = t.pg_transaction_no
			karvyfeed.SUB_TRXN_T = sub_tr_type
			karvyfeed.SIP_RFNO = sip_reg_no
			karvyfeed.SIP_RGDT = sip_reg_date
			karvyfeed.NOM_NAME = kyc1.nominee_name
			karvyfeed.NOM_RELA = kyc1.nominee_relation
			karvyfeed.KYC_FLG = "Y"
			karvyfeed.POA_STAT = "N"
			karvyfeed.MOD_TRXN = "W"
			karvyfeed.SIGN_VF = "Y"
			karvyfeed.CUST_ID = user.karvy_user_code
			karvyfeed.LOG_WT = "#{t.tr_date.strftime("%m%d%y")}$#{DateTime.now.strftime("%H:%M:%S")}$"
			#karvyfeed.LOG_PE = 
			#karvyfeed.DPID
			#karvyfeed.CLIENTID
			karvyfeed.NRI_SOF = nri_sof
			#karvyfeed.GUARD_RELA = kyc4.nominee_relation # correct this
			karvyfeed.PAN_VALI = "Y"
			karvyfeed.GPAN_VALI = gaurdian_pan_valid
			karvyfeed.J1PAN_VALI = joint1_pan_valid
			karvyfeed.J2PAN_VALI = joint2_pan_valid
			karvyfeed.NRI_ADD1 = nri_addl_address1 
			karvyfeed.NRI_ADD2 = nri_addl_address2
			karvyfeed.NRI_ADD3 = nri_addl_address3
			karvyfeed.NRI_CITY = nri_city
			karvyfeed.NRI_STATE = nri_state
			karvyfeed.NRI_COUN = nri_country
			karvyfeed.NRI_PIN = nri_pincode
			karvyfeed.NOM_DOB = n_dob
			karvyfeed.NOM_PERC = 100
			#karvyfeed.NOM_ADD1
			#karvyfeed.NOM_ADD2
			#karvyfeed.NOM_ADD3
			#karvyfeed.NOM_CITY
			#karvyfeed.NOM_STATE
			#karvyfeed.NOM_COUN
			#karvyfeed.NOM_PIN
			#karvyfeed.NOM_EMAIL
			#karvyfeed.NOM_MOB
			#karvyfeed.NOM1_NAME
			#karvyfeed.NOM1_RELA
			#karvyfeed.NOM1_DOB
			#karvyfeed.NOM1_PERC
			#karvyfeed.NOM1_ADD1
			#karvyfeed.NOM1_ADD2
			#karvyfeed.NOM1_ADD3
			#karvyfeed.NOM1_CITY
			#karvyfeed.NOM1_STATE
			#karvyfeed.NOM1_COUN
			#karvyfeed.NOM1_PIN
			#karvyfeed.NOM1_EMAIL
			#karvyfeed.NOM1_MOB
			#karvyfeed.NOM2_NAME
			#karvyfeed.NOM2_RELA
			#karvyfeed.NOM2_DOB
			#karvyfeed.NOM2_PERC
			#karvyfeed.NOM2_ADD1
			#karvyfeed.NOM2_ADD2
			#karvyfeed.NOM2_ADD3
			#karvyfeed.NOM2_CITY
			#karvyfeed.NOM2_STATE
			#karvyfeed.NOM2_COUN
			#karvyfeed.NOM2_PIN
			#karvyfeed.NOM2_EMAIL
			#karvyfeed.NOM2_MOB
			karvyfeed.FIRC_STA = firc_sta
			karvyfeed.SIP_STDT = start_date
			karvyfeed.SIP_ENDT = end_date
			karvyfeed.SIP_NOINST = no_of_inst
			karvyfeed.SIP_FREQ = 'M'
			karvyfeed.EUIN = "E071888"
			karvyfeed.EUIN_OPTIN = t.euin_status
			#karvyfeed.E1
			#karvyfeed.E2
			#karvyfeed.E3
			#karvyfeed.E4
			#karvyfeed.E5
			#karvyfeed.E6

			karvyfeed.save
			t.registrar_tr_status = "Feed sent"
			t.save
			builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
			xml.file {
			  xml.request_dtl {
			    xml.AMC_CODE "#{karvyfeed.AMC_CODE}"
				xml.BROKE_CD  "ARN-86572"
				xml.SBBR_CODE "#{karvyfeed.SBBR_CODE}"
				xml.USER_CODE "#{karvyfeed.USER_CODE}" 
				xml.USR_TXN_NO "#{karvyfeed.USR_TXN_NO}"  
				xml.APPL_NO "#{karvyfeed.APPL_NO}"
				xml.FOLIO_NO "#{karvyfeed.FOLIO_NO}"
			 	xml.CK_DIG_NO "#{karvyfeed.CK_DIG_NO}"
				xml.TRXN_TYPE "#{karvyfeed.TRXN_TYPE}"
				xml.SCH_CODE "#{karvyfeed.SCH_CODE}"
				xml.FIRST_NAME "#{karvyfeed.FIRST_NAME}"
				xml.JONT_NAME1 "#{karvyfeed.JONT_NAME1}"
				xml.JONT_NAME2 "#{karvyfeed.JONT_NAME2}"
				xml.ADD1 "#{karvyfeed.ADD1}"
				xml.ADD2 "#{karvyfeed.ADD2}"
				xml.ADD3 "#{karvyfeed.ADD3}"
				xml.CITY "#{karvyfeed.CITY}"
				xml.PINCODE "#{karvyfeed.PINCODE}"
				xml.PHONE_OFF "#{karvyfeed.PHONE_OFF}"
				xml.MOBILE_NO "#{karvyfeed.MOBILE_NO}"
				xml.TRXN_DATE "#{karvyfeed.TRXN_DATE}"
				xml.TRXN_TIME "#{karvyfeed.TRXN_TIME}"
				xml.UNITS "#{karvyfeed.UNITS}"
				xml.AMOUNT "#{karvyfeed.AMOUNT}"
				xml.CLOS_AC_CH "#{karvyfeed.CLOS_AC_CH}"
				xml.DOB "#{karvyfeed.DOB}"
				xml.GUARDIAN "#{karvyfeed.GUARDIAN}"
				xml.TAX_NUMBER "#{karvyfeed.TAX_NUMBER}"
				xml.PHONE_RES "#{karvyfeed.PHONE_RES}"
				xml.FAX_OFF "#{karvyfeed.FAX_OFF}"
				xml.FAX_RES "#{karvyfeed.FAX_RES}"
				xml.EMAIL "#{karvyfeed.EMAIL}"
				xml.ACCT_NO "#{karvyfeed.ACCT_NO}"
				xml.ACCT_TYPE "#{karvyfeed.ACCT_TYPE}"
				xml.BANK_NAME "#{karvyfeed.BANK_NAME}"
				xml.BR_NAME "#{karvyfeed.BR_NAME}"
				xml.BANK_CITY "#{karvyfeed.BANK_CITY}"
				xml.REINV_TAG "#{karvyfeed.REINV_TAG}"
				xml.HOLD_NATUR "#{karvyfeed.HOLD_NATUR}"
				xml.OCC_CODE "#{karvyfeed.OCC_CODE}"
				xml.TAX_STATUS "#{karvyfeed.TAX_STATUS}"
				xml.REMARKS "#{karvyfeed.REMARKS}"
				xml.STATE "#{karvyfeed.STATE}"
				xml.PAN_2_HLDR "#{karvyfeed.PAN_2_HLDR}"
				xml.PAN_3_HLDR "#{karvyfeed.PAN_3_HLDR}"
				xml.GUARD_PAN "#{karvyfeed.GUARD_PAN}"
				xml.LOCATION "#{karvyfeed.LOCATION}"
				xml.UINNO "#{karvyfeed.UINNO}"
				xml.FORM6061 "#{karvyfeed.FORM6061}"
				xml.FORM6061J1 "#{karvyfeed.FORM6061J1}"
				xml.FORM6061J2 "#{karvyfeed.FORM6061J2}"
				xml.PAY_MEC "#{karvyfeed.PAY_MEC}"
				xml.RTGS_CD  "#{karvyfeed.RTGS_CD }"
				xml.NEFT_CD "#{karvyfeed.NEFT_CD}"
				xml.MICR_CD "#{karvyfeed.MICR_CD}"
				xml.DEPBANK "#{karvyfeed.DEPBANK}"
				xml.DEP_ACNO "#{karvyfeed.DEP_ACNO}"
				xml.DEP_DATE "#{karvyfeed.DEP_DATE}"
				xml.DEP_RFNo "#{karvyfeed.DEP_RFNo}"
				xml.SUB_TRXN_T "#{karvyfeed.SUB_TRXN_T}"
				xml.SIP_RFNO "#{karvyfeed.SIP_RFNO}"
				xml.SIP_RGDT "#{karvyfeed.SIP_RGDT}"
				xml.NOM_NAME "#{karvyfeed.NOM_NAME}"
				xml.NOM_RELA "#{karvyfeed.NOM_RELA}"
				xml.KYC_FLG "#{karvyfeed.KYC_FLG}"
				xml.POA_STAT "#{karvyfeed.POA_STAT}"
				xml.MOD_TRXN "#{karvyfeed.MOD_TRXN}"
				xml.SIGN_VF "#{karvyfeed.SIGN_VF}"
				xml.CUST_ID "#{karvyfeed.CUST_ID}"
				xml.LOG_WT "#{karvyfeed.LOG_WT}"
				xml.LOG_PE "#{karvyfeed.LOG_PE}"
				xml.DPID "#{karvyfeed.DPID}"
				xml.CLIENTID "#{karvyfeed.CLIENTID}"
				xml.NRI_SOF "#{karvyfeed.NRI_SOF}"
				xml.GUARD_RELA "#{karvyfeed.GUARD_RELA}"
				xml.PAN_VALI "#{karvyfeed.PAN_VALI}"
				xml.GPAN_VALI "#{karvyfeed.GPAN_VALI}"
				xml.J1PAN_VALI "#{karvyfeed.J1PAN_VALI}"
				xml.J2PAN_VALI "#{karvyfeed.J2PAN_VALI}"
				xml.NRI_ADD1 "#{karvyfeed.NRI_ADD1}"
				xml.NRI_ADD2 "#{karvyfeed.NRI_ADD2}"
				xml.NRI_ADD3 "#{karvyfeed.NRI_ADD3}"
				xml.NRI_CITY "#{karvyfeed.NRI_CITY}"
				xml.NRI_STATE "#{karvyfeed.NRI_STATE}"
				xml.NRI_COUN "#{karvyfeed.NRI_COUN}"
				xml.NRI_PIN "#{karvyfeed.NRI_PIN}"
				xml.NOM_DOB "#{karvyfeed.NOM_DOB}"
				xml.NOM_PERC "#{karvyfeed.NOM_PERC}"
				xml.NOM_ADD1 "#{karvyfeed.NOM_ADD1}"
				xml.NOM_ADD2 "#{karvyfeed.NOM_ADD2}"
				xml.NOM_ADD3 "#{karvyfeed.NOM_ADD3}"
				xml.NOM_CITY "#{karvyfeed.NOM_CITY}"
				xml.NOM_STATE "#{karvyfeed.NOM_STATE}"
				xml.NOM_COUN "#{karvyfeed.NOM_COUN}"
				xml.NOM_PIN "#{karvyfeed.NOM_PIN}"
				xml.NOM_EMAIL "#{karvyfeed.NOM_EMAIL}"
				xml.NOM_MOB "#{karvyfeed.NOM_MOB}"
				xml.NOM1_NAME "#{karvyfeed.NOM1_NAME}"
				xml.NOM1_RELA "#{karvyfeed.NOM1_RELA}"
				xml.NOM1_DOB "#{karvyfeed.NOM1_DOB}"
				xml.NOM1_PERC "#{karvyfeed.NOM1_PERC}"
				xml.NOM1_ADD1 "#{karvyfeed.NOM1_ADD1}"
				xml.NOM1_ADD2 "#{karvyfeed.NOM1_ADD2}"
				xml.NOM1_ADD3 "#{karvyfeed.NOM1_ADD3}"
				xml.NOM1_CITY "#{karvyfeed.NOM1_CITY}"
				xml.NOM1_STATE "#{karvyfeed.NOM1_STATE}"
				xml.NOM1_COUN "#{karvyfeed.NOM1_COUN}"
				xml.NOM1_PIN "#{karvyfeed.NOM1_PIN}"
				xml.NOM1_EMAIL "#{karvyfeed.NOM1_EMAIL}"
				xml.NOM1_MOB "#{karvyfeed.NOM1_MOB}"
				xml.NOM2_NAME "#{karvyfeed.NOM2_NAME}"
				xml.NOM2_RELA "#{karvyfeed.NOM2_RELA}"
				xml.NOM2_DOB "#{karvyfeed.NOM2_DOB}"
				xml.NOM2_PERC "#{karvyfeed.NOM2_PERC}"
				xml.NOM2_ADD1 "#{karvyfeed.NOM2_ADD1}"
				xml.NOM2_ADD2 "#{karvyfeed.NOM2_ADD2}"
				xml.NOM2_ADD3 "#{karvyfeed.NOM2_ADD3}"
				xml.NOM2_CITY "#{karvyfeed.NOM2_CITY}"
				xml.NOM2_STATE "#{karvyfeed.NOM2_STATE}"
				xml.NOM2_COUN "#{karvyfeed.NOM2_COUN}"
				xml.NOM2_PIN "#{karvyfeed.NOM2_PIN}"
				xml.NOM2_EMAIL "#{karvyfeed.NOM2_EMAIL}"
				xml.NOM2_MOB "#{karvyfeed.NOM2_MOB}"
				xml.FIRC_STA "#{karvyfeed.FIRC_STA}"
				xml.SIP_STDT "#{karvyfeed.SIP_STDT}"
				xml.SIP_ENDT "#{karvyfeed.SIP_ENDT}"
				xml.SIP_NOINST "#{karvyfeed.SIP_NOINST}"
				xml.SIP_FREQ "#{karvyfeed.SIP_FREQ}"
				xml.EUIN "#{karvyfeed.EUIN}"
				xml.EUIN_OPTIN "#{karvyfeed.EUIN_OPTIN}"
				xml.E1 "#{karvyfeed.E1}"
				xml.E2 "#{karvyfeed.E2}"
				xml.E3 "#{karvyfeed.E3}"
				xml.E4 "#{karvyfeed.E4}"
				xml.E5 "#{karvyfeed.E5}"
				xml.E6 "#{karvyfeed.E6}"
				
		
			

			    
			  }
			}
			end
			@sh =  builder.to_xml




		end
		
	end




	def cams_upload_feed
		transactions = Transaction.find(:all, :conditions => ["registrar_tr_status = ? AND pg_tr_status = ? AND registrar = ? ","Invoice", "PAID", "Cams"])
		transactions.each do |t|
			cams_data = CamsData.new
			fund = Fund.find_by_id(t.fund_id)
			bank = Bank.find_by_id(t.bank_id)
			user = User.find_by_id(t.user_id)
			kyc1= Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ? ",user.id, "1"])
			joint_name1 = ''
			joint_name2 = ''
			joint1_pan = ''
			joint2_pan = ''
			joint1_pan_valid = ''
			joint2_pan_valid = ''
			holding_nature = "SI"
			if user.holding_type == "2"
				kyc2= Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ? ",user.id, "2"])
				joint_name1 = kyc2.first_name+kyc2.last_name
				joint1_pan = kyc2.pan
				holding_nature = "AS"
				joint1_pan_valid = 'Y'
			end
			if user.holding_type == "3"
				kyc2= Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ? ",user.id, "2"])
				joint_name1 = kyc2.first_name+kyc2.last_name
				joint1_pan = kyc2.pan
				holding_nature = "AS"
				joint1_pan_valid = 'Y'
				kyc3= Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ? ",user.id, "3"])
				joint_name3 = kyc3.first_name+kyc3.last_name
				joint2_pan = kyc3.pan
				joint2_pan_valid = 'Y'
			end		
			cams_data.transaction_id = t.id
			if t.folio_id
				if t.folio_id.include?('/')
					folio = t.folio_id.split('/')
				else
					folio = [t.folio_id,'']
				end
			else
				folio = ['','']
			end

			if t.amount
				units= ''
				amount = t.amount
			else
				units = t.units
				amount = ''
			end
			gaurdian_name = ''
			gaurdian_pan = ''
			gaurdian_pan_valid = ''
			if user.holding_type == '7'
				kyc4= Kyc.find(:first, :conditions => ["user_id = ? AND holding_priority = ? ",user.id, "4"])
				gaurdian_name = "#{kyc4.first_name} #{kyc4.last_name}"
				gaurdian_pan = kyc4.pan
				gaurdian_pan_valid = 'Y'
			end
			occupation = OccupationMaster.find_by_description(kyc1.occupation)
			occupation_code = occupation.cams_code
			state = StateMaster.find_by_description(kyc1.c_state)
			state_code = state.cams_code
			location = CityMaster.find_by_description(kyc1.c_city_town_village)
			location_code = location.cams_code
			if t.tr_mode == "SIP"
				sub_tr_type = 'S'
				sip_reg_date = t.sip_start_date
				sip_reg_no = t.sip_registration_no
				no_of_inst = t.sip_installments
				sip_freq = 'OM'
				start_date = t.sip_start_date.strftime("%m/%d/%Y")
				end_date = (t.sip_start_date + no_of_inst.months).strftime("%m/%d/%Y")
				installment_no = t.sip_installment_count
			else
				sub_tr_type = ''
				sip_reg_date = ''
				sip_reg_no = ''
				no_of_inst = '' 
				sip_freq = ''
				start_date = ''
				end_date = ''
				installment_no = ''

			end
			if fund.category == "Debt:Liquid Fund"
				pricing = "H"
			else
				pricing = "F"
			end

			nri_addl_address1 = ''
			nri_addl_address2 = ''
			nri_addl_address3 = ''
			nri_city = ''
			nri_state = ''
			nri_country = ''
			nri_pincode = ''
			checkflag = ''
			if user.holding_type == '4' 
				nri_addl_address1 = kyc1.c_house_no
				nri_addl_address2 = kyc1.c_street_name
				nri_addl_address3 = kyc1.c_area_name
				nri_city = kyc1.c_city_town_village
				nri_state = kyc1.c_state
				nri_country = kyc1.c_country
				nri_pincode = kyc1.c_postal_code
				checkflag = 'Y'
			end
			if user.holding_type == '5'
				nri_addl_address1 = kyc1.c_house_no
				nri_addl_address2 = kyc1.c_street_name
				nri_addl_address3 = kyc1.c_area_name
				nri_city = kyc1.c_city_town_village
				nri_state = kyc1.c_state
				nri_country = kyc1.c_country
				nri_pincode = kyc1.c_postal_code
				checkflag = 'Y'
			end
			if kyc1.nominee_minor_flag == 'Y'
				n_dob = kyc1.nominee_dob
				n_minor_flag = 'Y'
				n_gaurdian = kyc1.nominee_gaurdian
			else
				n_dob = ''
				n_minor_flag = ''
				n_gaurdian = ''
			end

			if kyc1.nominee_flag
				nomination_opted = 'Y'
			else
				nomination_opted = 'N'
			end
			if t.tr_mode = "Full Redemption"
				close_account = 'Y'
			else
				close_account = ''
			end

			cams_data.sent_feed =  "#{fund.registrar_amc_code}|RVPON||RVSTP|#{t.tr_id}||#{folio[0]}|#{folio[1]}|#{t.tr_type}
									|#{fund.registrar_scheme_code}|#{kyc1.first_name+kyc1.last_name}|#{joint_name1}
									|#{joint_name2}|#{kyc1.c_house_no}|#{kyc1.c_street_name}|#{kyc1.c_area_name}|#{kyc1.c_city_town_village}
									|#{kyc1.c_postal_code}||#{DateTime.now.strftime("%m/%d/%Y")}|#{DateTime.now.strftime("%H:%M:%S")}
									|#{units}|#{amount}|#{close_account}|#{kyc1.date_of_birth}|#{gaurdian_name}|#{kyc1.pan}||||#{kyc1.c_email}|#{bank.account_num}|#{bank.account_type}
									|#{bank.name_of_bank}|#{bank.branch_address}|#{bank.city}|#{t.reinvestment_tag}|#{holding_nature}|#{occupation_code}|#{user.tax_status}
									|#{t.tr_id}$#{DateTime.now.strftime("%m-%d-%y")}$#{DateTime.now.strftime("%H:%M:%S")}
									|#{state_code}|#{sub_tr_type}|DC|||||#{location_code}|DC|#{pricing}|#{joint1_pan}|#{joint2_pan}
									|#{kyc1.nominee_name}|#{kyc1.nominee_relation}|#{gaurdian_pan}|||Y|#{gaurdian_pan_valid}
									|#{joint1_pan_valid}|#{joint2_pan_valid}||||||#{sip_reg_date}|||||#{bank.ifsc_code}|#{bank.ifsc_code}
									|E|#{kyc1.c_mobile}||N|W|Y|#{nri_addl_address1}|#{nri_addl_address2}|#{nri_addl_address3}
									|#{nri_city}|#{nri_state}|#{nri_country}|#{nri_pincode}||||||||#{checkflag}|N|Y|Y|#{sip_reg_no}
									|#{no_of_inst}|#{sip_freq}|#{start_date}|#{end_date}|#{installment_no}|#{n_dob}|#{n_minor_flag}|#{n_gaurdian}
									|||||||N|N|N|N|||||||||#{t.euin_status}|E071888|#{nomination_opted}||Y"

			cams_data.save
			t.registrar_tr_status = "Feed sent"
			t.save
			@sh = cams_data.sent_feed
		end
		
	end

	def cams_import_feed
	  Camsfeed.import(params[:file])
	  camsfeeds = Camsfeed.all
	  camsfeeds.each do |c|
	  	transaction = Transaction.find_by_tr_id(c.usrtrxno)
	  	if transaction
	  		if c.usercode == "RVPON"
	  			if c.remarks.length > 1
	  				transaction.registrar_tr_status = c.remarks
	  				transaction.save
	  			else
	  				transaction.amount = c.amount
	  				transaction.units = c.units
	  				transaction.price_per_unit = c.purprice
	  				transaction.registrar_tr_status = "Sucess"
	  				transaction.folio_id = c.folio_no
	  				transaction.date = c.traddate	
	  				transaction.save
	  				holding = Holding.find_or_create_by_user_id_and_folio_and_fund_id(transaction.user_id,transaction.folio_id,transaction.fund_id)
	  				if transaction.tr_type
	  					holding.units = holding.units + transaction.units
	  					holding.buy_value = holding.buy_value + transaction.amount
	  					fund = Fund.find_by_id(transaction.fund_id)
	  					holding.amc = fund.registrar_amc_code
	  					holding.save
	  					# c.destroy
	  				end
	  			end
	  		else
	  			transaction.registrar_tr_status = "User Code does not match"
	  			transaction.save
	  		end
	  	end
	  end
	  redirect_to root_url, notice: "Cams feed imported."
	end




end
