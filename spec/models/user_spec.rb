require 'spec_helper'

describe User do

  it 'should create one with a valid password and email' do

    user = User.create!(email: 'example@domain.com', password: 'example1', password_confirmation: 'example1')
    user.id.should be_present

  end

  it 'should not allow a user creating without a valid password confirmation' do

    lambda do
      User.create!(email: 'example@domain.com', password: 'example1', password_confirmation: 'example2')
    end.should raise_error

  end

end
