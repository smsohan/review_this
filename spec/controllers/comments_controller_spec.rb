require 'spec_helper'


describe CommentsController do
  include Devise::TestHelpers

  def login
    @user = User.create!(name: 'example', email: 'example@domain.com', password: 'example1', password_confirmation: 'example1')
    sign_in @user
  end


  context "#create" do

    it 'redirects to login page when user is not logged in' do

      post :create, comment: {bid_id: 1}

      response.should redirect_to new_user_session_path
    end

    it 'responds with unauthorized when user is not the bidder or requestor' do
      login

      other_user = User.create!(name: 'other', email: 'other@domain.com', password: 'other1', password_confirmation: 'other1')
      review_request = ReviewRequest.new(title: 'review'){|rr| rr.requestor = other_user; rr.save!}

      bid = Bid.new(bid_amount: 100, bid_message: 'Interested'){|b| b.bidder = other_user; b.review_request =  review_request;  b.save!}

      post :create, comment: {bid_id: bid.id}

      response.status.should == 401
    end


    it 'saves the comment on the bid' do
      login

      other_user = User.create!(name: 'other', email: 'other@domain.com', password: 'other1', password_confirmation: 'other1')
      review_request = ReviewRequest.new(title: 'review'){|rr| rr.requestor = other_user; rr.save!}

      bid = Bid.new(bid_amount: 100, bid_message: 'Interested'){|b| b.bidder = @user; b.review_request =  review_request;  b.save!}

      post :create, comment: {bid_id: bid.id, body: 'Please respond'}

      response.status.should == 201

      comment = assigns(:comment)
      comment.bid.should == bid
      comment.user.should == @user
      comment.body.should == 'Please respond'
    end

    it 'sends email notification to the receipient' do
      login

      other_user = User.create!(name: 'other', email: 'other@domain.com', password: 'other1', password_confirmation: 'other1')
      review_request = ReviewRequest.new(title: 'review'){|rr| rr.requestor = other_user; rr.save!}

      bid = Bid.new(bid_amount: 100, bid_message: 'Interested'){|b| b.bidder = @user; b.review_request =  review_request;  b.save!}

      mail = mock
      mail.should_receive(:deliver)
      CommentNotifier.should_receive(:new_comment).and_return(mail)

      post :create, comment: {bid_id: bid.id, body: 'Please respond'}
    end

  end

end
