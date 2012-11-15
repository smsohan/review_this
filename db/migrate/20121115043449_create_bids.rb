class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :review_request_id
      t.integer :bidder_id
      t.integer :bid_amount
      t.text :bid_message

      t.timestamps
    end
  end
end
