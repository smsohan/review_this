class Bid < ActiveRecord::Base
  attr_accessible :bid_amount, :bid_message, :review_request_id

  belongs_to :review_request
  belongs_to :bidder, class_name: 'User'

  validates :bid_amount, presence: true
  validates :bidder_id, presence: true
  validates :bid_message, presence: true
  validates :review_request_id, presence: true

  def authorized?(bidder)
    review_request.requestor != bidder
  end

end
