require 'spec_helper'

describe BidsController do

  include Devise::TestHelpers

  def login
    @user = User.create!(name: 'example', email: 'example@domain.com', password: 'example1', password_confirmation: 'example1')
    sign_in @user
  end


  context "#new" do

    it 'should redirect to login page' do
      get :new, review_request_id: 1

      response.should redirect_to new_user_session_path
    end

    it 'should show the form' do
      login

      review_request = ReviewRequest.new(title: 'review'){|rr| rr.requestor = @user; rr.save!}

      get :new, review_request_id: review_request.id

      response.should render_template :new
      assigns(:bid).review_request.should == review_request
    end

  end

  context '#create' do

    it "redirects to login page" do
      post :create

      response.should redirect_to new_user_session_path
    end

    it 'cannot create a bid on its own review request' do
      login

      review_request = ReviewRequest.new(title: 'review'){|rr| rr.requestor = @user; rr.save!}

      post :create, bid: { review_request_id: review_request.id, bid_amount: 100 }
      response.status.should == 401
    end

    it 'creates a bid' do
      login

      other_user = User.create!(name: 'other', email: 'other@domain.com', password: 'other1', password_confirmation: 'other1')
      review_request = ReviewRequest.new(title: 'review'){|rr| rr.requestor = other_user; rr.save!}

      post :create, bid: { review_request_id: review_request.id, bid_amount: 100, bid_message: 'Interested' }

      response.should redirect_to review_request_path(review_request)

      bid = assigns(:bid)
      bid.bidder.should == @user
      bid.review_request.should == review_request
      bid.bid_amount.should == 100
      bid.bid_message.should == 'Interested'
    end

  end

  context "#update" do

    it 'redirects to the login page' do
      put :update, id: 1

      response.should redirect_to new_user_session_path
    end


    it 'cannot update another bidders bid' do
      login

      other_user = User.create!(name: 'other', email: 'other@domain.com', password: 'other1', password_confirmation: 'other1')
      bid = Bid.new(bid_amount: 100, bid_message: 'Interested'){|b| b.bidder = other_user; b.review_request_id =  1;  b.save!}

      put :update, id: bid.id, bid: { bid_amount: 130 }

      response.status.should == 401

      bid.reload
      bid.bid_amount.should == 100
    end

    it 'can update her own bid' do
      login

      other_user = User.create!(name: 'other', email: 'other@domain.com', password: 'other1', password_confirmation: 'other1')
      review_request = ReviewRequest.new(title: 'review'){|rr| rr.requestor = other_user; rr.save!}

      bid = Bid.new(bid_amount: 100, bid_message: 'Interested'){|b| b.bidder = @user; b.review_request =  review_request;  b.save!}

      put :update, id: bid.id, bid: { bid_amount: 130 }

      bid.reload
      bid.bid_amount.should == 130

      response.should redirect_to review_request_path(review_request)
    end

  end

end
