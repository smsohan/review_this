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

end