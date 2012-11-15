require "spec_helper"

describe ReviewRequest do
  context '.recent' do

    it 'should return blank if none found' do
      ReviewRequest.recent(20).should == []
    end

    it 'should return the recent ones' do
      user = User.create!(name: 'user', email: 'example@domain.com', password: 'example1', password_confirmation: 'example1')

      rr_1 = ReviewRequest.new {|rr| rr.requestor = user; rr.updated_at = 20.days.ago; rr.save!}
      rr_2 = ReviewRequest.new {|rr| rr.requestor = user; rr.updated_at = 10.days.ago; rr.save!}
      rr_3 = ReviewRequest.new {|rr| rr.requestor = user; rr.updated_at = 1.days.ago; rr.save!}

      ReviewRequest.recent(2).should == [rr_3, rr_2]
    end

  end

  context "#can_bid?" do

    before(:each) do
      @user = User.create!(name: 'user', email: 'example@domain.com', password: 'example1', password_confirmation: 'example1')
      @review_request = ReviewRequest.new {|rr| rr.requestor = @user;}
    end

    it 'returns true for a user who is not the requestor' do
      @review_request.can_bid?(User.new).should == true
    end

    it 'returns false for the requestor' do
      @review_request.can_bid?(@user).should == false
    end

    it 'can only bid once' do
      user = User.create!(name: 'other', email: 'other@domain.com', password: 'other1', password_confirmation: 'other1')
      bid = Bid.new{|b| b.bidder = user}

      @review_request.bids << bid

      @review_request.can_bid?(user).should == false
    end

  end

  context '#highest_bid' do

    before(:each) do
      @user = User.create!(name: 'user', email: 'example@domain.com', password: 'example1', password_confirmation: 'example1')
      @review_request = ReviewRequest.new(title: 'example') {|rr| rr.requestor = @user;}
    end

    it 'returns 0 if none found' do
      @review_request.highest_bid.should == nil
    end

    it 'returns the highest bid amount if none found' do
      @review_request.save!

      other_user = User.create!(name: 'other', email: 'other@domain.com', password: 'other1', password_confirmation: 'other1')
      @review_request.bids.build(bid_amount: 100, bid_message: 'Interested'){|b| b.bidder = @user}
      @review_request.bids.build(bid_amount: 150, bid_message: 'Interested too'){|b| b.bidder = other_user}

      @review_request.save!

      @review_request.highest_bid.should == 150
    end
  end

  context '#bids_count' do

    before(:each) do
      @user = User.create!(name: 'user', email: 'example@domain.com', password: 'example1', password_confirmation: 'example1')
      @review_request = ReviewRequest.new(title: 'example') {|rr| rr.requestor = @user;}
    end

    it 'returns 0 if none found' do
      @review_request.bids_count.should == 0
    end

    it 'returns the number of bids' do
      @review_request.save!

      other_user = User.create!(name: 'other', email: 'other@domain.com', password: 'other1', password_confirmation: 'other1')
      @review_request.bids.build(bid_amount: 100, bid_message: 'Interested'){|b| b.bidder = @user}
      @review_request.bids.build(bid_amount: 150, bid_message: 'Interested too'){|b| b.bidder = other_user}

      @review_request.save!

      @review_request.bids_count.should == 2
    end
  end

  context "#bid_by" do
    it 'retuns the bid by the given user' do

      user = User.create!(name: 'user', email: 'example@domain.com', password: 'example1', password_confirmation: 'example1')
      review_request = ReviewRequest.new(title: 'example') {|rr| rr.requestor = user;}

      review_request.save!

      other_user = User.create!(name: 'other', email: 'other@domain.com', password: 'other1', password_confirmation: 'other1')
      review_request.bids.build(bid_amount: 100, bid_message: 'Interested'){|b| b.bidder = user}
      review_request.bids.build(bid_amount: 150, bid_message: 'Interested too'){|b| b.bidder = other_user}

      review_request.save!

      review_request.bid_by(user).bid_amount.should == 100
    end
  end


end