class TransactionsController < ApplicationController
	def investment
		@funds = Fund.find(params[:fund_ids])
		@banks = Bank.find(:all, :conditions => ["user_id = ?  ",current_user.id,])
  	   
	end

	def invoice
		existing_transactions = Transaction.find(:all, :conditions => ["user_id = ? AND pg_tr_status = ?  ",current_user.id,"Invoice"])
		if existing_transactions.empty? == false
			params[:transactions].each do |transaction1|
				transaction = Transaction.where(:user_id => current_user.id , :pg_tr_status => "Invoice", :fund_id =>transaction1["fund_id"]).first
				transaction.user_id = current_user.id
				transaction.bank_id = params[:bankid]
				transaction.tr_mode = params[:tr_mode]
				transaction.euin_status = params[:euin]
				transaction.tr_date = DateTime.now.to_date

				transaction.update_attributes(transaction1)
				transaction.tr_id = "RV-%.8d" % transaction.id # same trid for switch in switch out..
				

				if transaction.tr_mode == "SIP"  
					transaction.sip_installment_count = 0
					transaction.sip_registration_no = "SIP-%.8d" % (transaction.id+10000) 
					due_transaction = DueTransaction.find_or_create_by(transaction_id: transaction.id)
					due_transaction.transaction_id = transaction.id
	      			due_transaction.due_date = transaction.sip_start_date
	      			due_transaction.sip_counter = 1
	      			due_transaction.sip_installments = transaction.sip_installments 
	      			due_transaction.save
	      			@sip_lumpsum = 1
	      		else
	      			due_transaction = DueTransaction.find_by_transaction_id(transaction.id)
	      			if due_transaction
	      				due_transaction.destroy

	      			end
	      			transaction.sip_registration_no = nil
	      			@sip_lumpsum = 0
				end
				transaction.save
			end	
		else
			params[:transactions].each do |transaction1|
				transaction = Transaction.new(transaction1)
				transaction.user_id = current_user.id
				transaction.bank_id = params[:bankid]
				transaction.tr_mode = params[:tr_mode]
				transaction.euin_status = params[:euin]
				transaction.tr_date = DateTime.now.to_date

				transaction.save
				transaction.tr_id = "RV-%.8d" % transaction.id # same trid for switch in switch out..
				if transaction.tr_mode == "SIP"  
					transaction.sip_installment_count = 0
					transaction.sip_registration_no = "SIP-%.8d" % (transaction.id+10000) 
					due_transaction = DueTransaction.new # dont update tr table from due table here
					due_transaction.transaction_id = transaction.id
	      			due_transaction.due_date = transaction.sip_start_date
	      			due_transaction.sip_counter = 1
	      			due_transaction.sip_installments = transaction.sip_installments 
	      			due_transaction.save
	      			@sip_lumpsum = 1
	      		else
	      			@sip_lumpsum = 0
				end
				transaction.save
			end
		end
		@transactions_invoice = Transaction.find(:all, :conditions => ["user_id = ? AND pg_tr_status = ?  ",current_user.id, "Invoice"])


	end


end
