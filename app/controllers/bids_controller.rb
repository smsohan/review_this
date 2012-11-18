class BidsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @bids = Bid.all
  end

  def show
    @bid = Bid.find(params[:id])

    if @bid.bidder != current_user
      render text: 'Cannot see the details of other users bid', status: :unauthorized
    end
  end

  def new
    @bid = ReviewRequest.find(params[:review_request_id]).bids.build
  end

  def edit
    @bid = Bid.find(params[:id])
  end

  def create
    @bid = Bid.new(params[:bid])
    @bid.bidder = current_user

    unless @bid.authorized?(current_user)
      render text: 'Cannot bid on your own review request', status: :unauthorized
      return
    end

    if @bid.save
      BidNotifier.delay.new_bid(@bid)
      redirect_to review_request_path(@bid.review_request), notice: 'Bid was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @bid = Bid.find(params[:id])

    unless @bid.bidder == current_user
      render text: 'Cannot update others bid', status: :unauthorized
      return
    end

    if @bid.update_attributes(params[:bid])
      BidNotifier.delay.bid_updated(@bid)
      redirect_to review_request_path(@bid.review_request), notice: 'Bid was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @bid = Bid.find(params[:id])
    @bid.destroy
    redirect_to bids_url
  end
end
