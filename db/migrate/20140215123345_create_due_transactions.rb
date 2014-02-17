class CreateDueTransactions < ActiveRecord::Migration
  def change
    create_table :due_transactions do |t|
     
      t.integer :transaction_id
      t.date :due_date
      t.string :sip_registration_no
      t.string :sip_counter
      t.integer :sip_installments
      t.string :status
      t.timestamps
    end
  end
end
