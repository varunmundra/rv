class StaticPagesController < ApplicationController
  def home
  	if user_signed_in?
  		@kyc_exist = Kyc.find_by_user_id(current_user.id)
  		@banks = Bank.find(:all, :conditions => ["user_id = ? ",current_user.id])
    end
  end

  def sip_registration

    if user_signed_in?
      if current_user.id == 1
        @bank_users = User.find(:all, :conditions => ["bank_status = ? ", 2])
        @bank_users.each do |b|
          b.bank_status = "3"
          b.save
        end
        respond_to do |format|
          format.html
          format.xls 
        end
      end
    end

  end



  def import_sip_registration

    if user_signed_in?
      if current_user.id == 1
          case File.extname(params[:file].original_filename)
            when ".csv" then spreadsheet = Roo::Csv.new(params[:file].path, nil, :ignore)
            when ".xls" then spreadsheet = Roo::Excel.new(params[:file].path, nil, :ignore)
            when ".xlsx" then spreadsheet = Roo::Excelx.new(params[:file].path, nil, :ignore)
            else raise "Unknown file type: #{params[:file].original_filename}"
          end
          
          header = spreadsheet.row(1)
          (2..spreadsheet.last_row).each do |i|
            row = Hash[[header, spreadsheet.row(i)].transpose]

            bank = Bank.find_by_umrn(row["Unique Mandate Registration No (UMRN)"])
            
            if bank
              user = User.find_by_bank_id(bank.id)
              if row["Status"] == "Valid"   
                if row["Upper Limit Amount"] ==  bank.sip_upper_limit
                    if row["Start Date"] == bank.created_at.strftime("%d/%m/%Y").to_s && row["End Date"]== (bank.created_at+ bank.sip_validity.years).strftime("%d/%m/%Y").to_s
                        bank.sip_mandate_status = 3
                        user.bank_status = 4
                        bank.reason = "Uploaded Succesfully"
                        bank.save
                        user.save
                        flash[:notice]= "Uploaded Succesfully"
                    else
                        bank.reason = "Dates does not match"
                        user.bank_status = 5
                        user.save
                        bank.save
                        flash[:notice]= "Dates does not match"
                    end
                    
                else
                    bank.reason = "Upper Limit does not match"
                    user.bank_status = 5
                    user.save
                    bank.save
                    flash[:notice]= "Upper Limit does not match"
                end
              else
                  bank.reason = row["Reason"]
                  user.bank_status = 5
                  bank.save
                  user.save
                  flash[:notice]= "Invalid"
              end
            end

          end
      end
    end
    redirect_to root_url
  end
   


  def sip_transactions
    @str = ''
    if user_signed_in?

      if current_user.id == 1
        due_transactions = DueTransaction.find(:all, :conditions => ["due_date = ? ", DateTime.now.to_date])
        due_transactions.each do |t|     
          transaction = Transaction.find_by_id(t.transaction_id)
          t2 = transaction.dup
          t2.tr_date = t.due_date
          t2.sip_installment_count = t.sip_counter
          t2.pg_tr_status = "SIP req sent"  # stus update only after automatic mail is sent
          t2.save
          bank = Bank.find_by_id(t2.bank_id)
          fund = Fund.find_by_id(t2.fund_id)
          @str << "#{t2.id},#{bank.umrn},#{bank.first_holder},#{fund.pg_amc_code},#{fund.pg_scheme_code},#{t2.folio_id},#{t2.tr_date.strftime("%Y%m%d")},#{t2.amount}\n"
          t.sip_counter = t.sip_counter.to_i+1
          t.due_date = t.due_date + 1.month
          t.save
           if t.sip_counter == t.sip_installments
            t.destroy
          end
        end
        path = "#{Rails.root.to_s}/app/views/static_pages/siprequests.txt"
        File.open(path, "w+") do |f|
          f.write(@str)
        end
      end
    end
  end


  def import_sip_transaction
    if user_signed_in?
      if current_user.id == 1

        File.open(params[:file2].path, 'r') do |f1|  
          while line = f1.gets  
            a = line.split(",")
            transaction = Transaction.find_by_id(a[0])
            if transaction
              transaction.pg_transaction_no = a[10]
              transaction.pg_tr_status_reason = a[9]
              transaction.pg_tr_status = a[8]
              transaction.save
            end
            if transaction.amount != a[7].to_f
              transaction.pg_tr_status = "Paid but amount does not match"
              transaction.save
            end
          end  
        end 


      end
    end
  end

  def about
  end

  def products
  end
end
