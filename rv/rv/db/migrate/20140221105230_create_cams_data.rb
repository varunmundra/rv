class CreateCamsData < ActiveRecord::Migration
  def change
    create_table :cams_data do |t|
      t.integer :transaction_id
      t.text :sent_feed
      t.text :recieved_feed
      t.timestamps
    end
  end
end
