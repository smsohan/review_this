class ReviewRequest < ActiveRecord::Base
  attr_accessible :content, :title, :requestor, :reviewer

  belongs_to :requestor, class_name: 'User'
  belongs_to :reviewer, class_name: 'User'

  validates :requestor_id, presence: true

  has_many :bids, dependent: :destroy

  def self.recent(count)
    order('updated_at DESC').limit(count)
  end

  def can_bid?(user)
    requestor != user && bids.map(&:bidder_id).exclude?(user.id)
  end

  def highest_bid
    bids.maximum(:bid_amount)
  end

  def bids_count
    bids.count
  end

  def bid_by(user)
    bids.where(bidder_id: user.id).first
  end

  def can_see_content?(user)
    requestor == user || reviewer == user
  end

end
