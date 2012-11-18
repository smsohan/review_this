require "spec_helper"

describe CommentNotifier do
  context "#new_comment" do

    it 'sends the email to the recipient with the right subject' do
      requestor = User.create!(name: 'other', email: 'req@email.com', password: 'other1', password_confirmation: 'other1')
      review_request = ReviewRequest.new(title: 'Need resume reviewed'){|rr| rr.requestor = requestor; rr.save!}

      bid = Bid.new
      bid.review_request = review_request
      bid.bidder = User.new(email: 'bidder@email.com', name: 'Bidder')
      comment = Comment.new{|c| c.bid = bid; c.user = bid.bidder}

      email = CommentNotifier.new_comment(comment)
      email.to.should == ['req@email.com']
      email.subject.should == 'Bidder commented on Need resume reviewed'
    end

  end

end
