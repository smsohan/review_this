require "spec_helper"

describe ReviewRequestsController do
  include Devise::TestHelpers

  def login
    @user = User.create!(name: 'example', email: 'example@domain.com', password: 'example1', password_confirmation: 'example1')

    sign_in @user
  end

  context "#new" do

    it 'should redirect to login page' do
      get :new
      should redirect_to new_user_session_path
    end

    it 'should render the form' do
      login

      get :new

      should render_template :new
    end

  end


  context '#create' do

    it 'should redirect to login page' do
      post :create
      should redirect_to new_user_session_path
    end

    it 'should create the review request with the requestor' do
      login

      post :create, review_request: { title: 'Please review this' }

      review_request =  assigns(:review_request)

      review_request.requestor.should == @user
      review_request.title.should == 'Please review this'
    end

  end

  context "update" do

    it 'should redirect to login page' do
      put :update, id: 1
      should redirect_to new_user_session_path
    end

    it 'should not allow updating other users review request' do
      login

      other_user = User.create!(name: 'other', email: 'other@domain.com', password: 'other1', password_confirmation: 'other1')
      review_request = ReviewRequest.create!(title: 'other users review request'){|rr| rr.requestor = other_user; rr.save!}

      put :update, id: review_request.id, review_request: {title: 'new title'}

      response.status.should == 401
      assigns(:review_request).title.should == 'other users review request'

    end

    it 'should update its own review request' do
      login

      review_request = ReviewRequest.new(title: 'other users review request'){|rr| rr.requestor = @user; rr.save!}

      put :update, id: review_request.id, review_request: {title: 'new title'}

      assigns(:review_request).title.should == 'new title'
    end

  end

  context "destroy" do

    it 'should redirect to login page' do
      delete :destroy, id: 1
      should redirect_to new_user_session_path
    end

    it 'should not allow destroying other users review request' do
      login

      other_user = User.create!(name: 'other', email: 'other@domain.com', password: 'other1', password_confirmation: 'other1')
      review_request = ReviewRequest.create!(title: 'other users review request'){|rr| rr.requestor = other_user; rr.save!}

      delete :destroy, id: review_request.id

      response.status.should == 401
      assigns(:review_request).frozen?.should == false
    end

    it 'should delete its own review request' do
      login

      review_request = ReviewRequest.new(title: 'other users review request'){|rr| rr.requestor = @user; rr.save!}

      delete :destroy, id: review_request.id

      assigns(:review_request).frozen?.should == true
    end

  end

end