class CreateCamsfeeds < ActiveRecord::Migration
  def change
    create_table :camsfeeds do |t|
      t.string :amc_code
      t.string :folio_no
      t.string :prodcode
      t.string :scheme
      t.string :inv_name
      t.string :trxntype
      t.string :trxnno
      t.string :trxnmode
      t.string :trxnstat
      t.string :usercode
      t.string :usrtrxno
      t.date :traddate
      t.date :postdate
      t.float :purprice
      t.float :units
      t.float :amount
      t.string :brokcode
      t.string :subbrok
      t.string :brokperc
      t.string :brokcomm
      t.string :altfolio
      t.date :rep_date
      t.string :time1
      t.string :trxnsubtyp
      t.string :application_no
      t.string :trxn_nature
      t.float :tax
      t.float :total_tax
      t.string :te_15h
      t.string :micr_no
      t.string :remarks
      t.string :swflag
      t.string :old_folio
      t.string :seq_no
      t.string :reinvest_flag
      t.string :mult_brok
      t.float :stt
      t.string :location
      t.string :scheme_type
      t.string :tax_status
      t.float :load
      t.string :scanrefno
      t.string :pan
      t.float :inv_iin
      t.string :targ_src_scheme
      t.string :trxn_type_flag
      t.string :ticob_trtype
      t.string :ticob_trno
      t.date :ticob_posted_date
      t.string :dp_id
      t.float :trxn_charges
      t.float :eligib_amt
      t.string :src_of_txn
      t.string :trxn_suffix
      t.string :siptrxnno
      t.string :ter_location
      t.string :euin
      t.string :euin_valid
      t.string :euin_opted
      t.string :sub_brk_arn
      t.timestamps
    end
  end
end
