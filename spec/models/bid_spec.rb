require 'spec_helper'

describe Bid do
  context "#authorized?" do
    it "returns true when a user bids on a post by another user" do
      bid = Bid.new
      bid.review_request = ReviewRequest.new{|rr| rr.requestor = User.new}
      bid.authorized?(User.new).should == true
    end

    it "returns false when a user bids on her own post" do
      bid = Bid.new
      user = User.new
      bid.review_request = ReviewRequest.new{|rr| rr.requestor = user}
      bid.authorized?(user).should == false
    end
  end
end
