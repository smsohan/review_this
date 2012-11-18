class Comment < ActiveRecord::Base
  attr_accessible :bid_id, :body, :user_id

  belongs_to :bid
  belongs_to :user

  validates :bid_id, presence: true
  validates :user_id, presence: true
  validates :body, presence: true

  def recipient
    user == bid.bidder ? bid.requestor : bid.bidder
  end

end
