class BidNotifier < ActionMailer::Base
  default from: "from@example.com"

  def new_bid(bid)
    @bid = bid

    mail to: bid.review_request.requestor.email,
         subject: "New bid on #{bid.review_request.title}"
  end
end
