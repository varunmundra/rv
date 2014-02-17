class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :bank_id
      t.integer :fund_id
      t.string :tr_id
      t.string :reinvestment_tag #reinvestment or payout
      t.string :tr_type #purchase, redeem,
      t.string :tr_mode #P= L, SIP:  R= L, SWP, Switch= Switch in, switch out ,STP
      t.float :amount 
      t.float :units
      t.float :price_per_unit
      t.date :tr_date, :date
      t.date :sip_start_date
      t.string :sip_registration_no
      t.string :sip_frequency
      t.integer :sip_installments
      t.integer :sip_installment_count
      t.string :folio_id
      t.string :registrar
      t.string :registrar_tr_status
      t.string :registrar_tr_status_reason
      t.string :pg_tr_status
      t.string :pg_tr_status_reason
	  t.string :checksum
	  t.string :liq_non
	  t.string :error_status
	  t.string :error_desc
	  t.string :auth_status
	  t.float :transaction_charges
	  t.string :euin_status




      t.timestamps
    end
  end
end
