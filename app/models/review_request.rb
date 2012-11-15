class ReviewRequest < ActiveRecord::Base
  attr_accessible :content, :title

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

end
