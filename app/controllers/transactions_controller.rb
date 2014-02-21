class TransactionsController < ApplicationController
	def investment
		@funds = Fund.find(params[:fund_ids])
		@banks = Bank.find(:all, :conditions => ["user_id = ?  ",current_user.id,])
  	   
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
			transaction.tr_mode = params[:tr_mode]
			transaction.euin_status = params[:euin]
			transaction.tr_date = DateTime.now.to_date
			transaction.update_attributes(transaction1)
			transaction.tr_id = "RV-%.8d" % transaction.id # same trid for switch in switch out..
			if transaction.tr_mode == "SIP"  
				transaction.sip_installment_count = 0
				transaction.pg_tr_status = "SIP Setup"
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
		if @transactions_invoice.empty?
			redirect_to funds_path
		else
			if @transactions_invoice.first.tr_mode == "SIP"
				@sip_lumpsum = 1
			else
				@sip_lumpsum = 0
			end
		end
	end

	def ru
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
	    msgfrompg = params[:msgpg].delete(checksumreturn).chop
	    calculated_checksum = Digest::HMAC.hexdigest(msgfrompg, checksumkey, Digest::SHA256)
	    # calculated_checksum = calculated_checksum.upcase
	    if calculated_checksum == checksumreturn
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
		                t.pg_tr_status = 'SUCESS'
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






end
