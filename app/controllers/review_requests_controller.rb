class ReviewRequestsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @review_requests = ReviewRequest.all
  end

  def show
    @review_request = ReviewRequest.find(params[:id])
  end

  def new
    @review_request = ReviewRequest.new
  end

  def edit
    @review_request = ReviewRequest.find(params[:id])
  end

  def create
    @review_request = ReviewRequest.new(params[:review_request])
    @review_request.requestor = current_user

    if @review_request.save
      redirect_to @review_request, notice: 'Review request was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @review_request = ReviewRequest.find(params[:id])

    if @review_request.update_attributes(params[:review_request])
      redirect_to @review_request, notice: 'Review request was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @review_request = ReviewRequest.find(params[:id])
    @review_request.destroy
    redirect_to review_requests_url
  end
end
