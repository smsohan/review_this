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

    return unless valid_requestor?(@review_request)

    if @review_request.update_attributes(params[:review_request])
      redirect_to @review_request, notice: 'Review request was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @review_request = ReviewRequest.find(params[:id])

    return unless valid_requestor?(@review_request)

    @review_request.destroy
    redirect_to review_requests_url
  end

  private
  def valid_requestor?(review_request)
    return true if review_request.requestor == current_user

    render nothing: true, status: :unauthorized
    false
  end
end
