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

	def destroy
		transactions = Transaction.find(params[:transaction_ids])	
		transactions.each do |transaction|
			if transaction.tr_mode == "SIP"
				due_transaction = DueTransaction.find_by_transaction_id(transaction.id)
				due_transaction.destroy
			end
			transaction.destroy
		end
		redirect_to transactions_path
		
	end


end
