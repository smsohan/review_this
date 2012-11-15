class CreateReviewRequests < ActiveRecord::Migration
  def change
    create_table :review_requests do |t|
      t.integer :requestor_id
      t.integer :reviewer_id
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
