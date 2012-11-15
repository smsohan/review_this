require "spec_helper"

describe WelcomeController do
  include Devise::TestHelpers

  context '#index' do
    it 'should require login' do
      get :index
      should redirect_to new_user_session_path
    end

    it 'should render the page when logged in' do

      user = User.create!(name: 'example', email: 'example@domain.com', password: 'example1', password_confirmation: 'example1')
      sign_in user

      expected_review_requests = [ReviewRequest.new]
      ReviewRequest.should_receive(:recent).with(20).and_return(expected_review_requests)

      get :index

      response.should render_template :index
      assigns(:review_requests).should == expected_review_requests
    end

  end


end