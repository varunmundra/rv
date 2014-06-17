class AddDetailsToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :pg_order_number, :integer
    add_column :transactions, :pg_transaction_no, :string
  end
end
