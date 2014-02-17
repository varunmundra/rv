class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.integer :transaction_id
      t.text :registrar_feed
      t.text :registrar_reverse_feed	
      t.text :pg_feed
      t.text :pg_reverse_feed

      t.timestamps
    end
  end
end
