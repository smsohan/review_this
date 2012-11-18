class Bid < ActiveRecord::Base
  attr_accessible :bid_amount, :bid_message, :review_request_id

  belongs_to :review_request
  belongs_to :bidder, class_name: 'User'

  has_many :comments, dependent: :destroy, order: 'comments.created_at DESC'

  validates :bid_amount, presence: true
  validates :bidder_id, presence: true
  validates :bid_message, presence: true
  validates :review_request_id, presence: true

  delegate :requestor, to: :review_request, allow_nil: true

  def authorized?(bidder)
    review_request.requestor != bidder
  end

end
