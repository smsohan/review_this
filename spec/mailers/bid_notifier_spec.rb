require "spec_helper"

describe BidNotifier do

  context "#new_bid" do

    it 'should set the email parameters based on the bid' do
      requestor = User.create!(name: 'other', email: 'req@email.com', password: 'other1', password_confirmation: 'other1')
      review_request = ReviewRequest.new(title: 'University SOP'){|rr| rr.requestor = requestor; rr.save!}

      bid = Bid.new
      bid.review_request = review_request
      bid.bidder = User.new(email: 'bidder@email.com', name: 'bidder')

      mail = BidNotifier.new_bid(bid)
      mail.to.should == ['req@email.com']
      mail.subject.should == 'New bid on University SOP'
    end

  end

  context "#bid_updated" do

    it 'should set the email parameters based on the bid' do
      requestor = User.create!(name: 'other', email: 'req@email.com', password: 'other1', password_confirmation: 'other1')
      review_request = ReviewRequest.new(title: 'University SOP'){|rr| rr.requestor = requestor; rr.save!}

      bid = Bid.new
      bid.review_request = review_request
      bid.bidder = User.new(email: 'bidder@email.com', name: 'bidder')

      mail = BidNotifier.bid_updated(bid)
      mail.to.should == ['req@email.com']
      mail.subject.should == 'Updated bid on University SOP'
    end

  end

end
