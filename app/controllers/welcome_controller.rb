class WelcomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @review_requests = ReviewRequest.recent(20)
  end
end
