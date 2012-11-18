class BidNotifier < ActionMailer::Base
  default from: "from@example.com"

  def new_bid(bid)
    @bid = bid

    mail to: bid.review_request.requestor.email,
         subject: "New bid on #{bid.review_request.title}"
  end

  def bid_updated(bid)
    @bid = bid

    mail to: bid.review_request.requestor.email,
         subject: "Updated bid on #{bid.review_request.title}"
  end

end
