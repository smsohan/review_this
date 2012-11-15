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

      get :index

      response.should render_template :index
    end

  end


end