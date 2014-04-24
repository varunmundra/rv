class CreateHoldings < ActiveRecord::Migration
  def change
    create_table :holdings do |t|

      t.integer :user_id
      t.integer :fund_id
      t.string :folio
      t.float :units , :default => 0.0
      t.float :buy_value , :default => 0.0
      t.float :current_value, :default => 0.0
      t.string :amc
      t.string :extra1
      t.float :dividend_amt, :default => 0.0
      t.timestamps
    end
  end
end
