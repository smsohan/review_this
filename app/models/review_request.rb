class ReviewRequest < ActiveRecord::Base
  attr_accessible :content, :requestor_id, :reviewer_id, :title

  belongs_to :requestor, class_name: 'User'
  belongs_to :reviewer, class_name: 'User'

end
