class CommentNotifier < ActionMailer::Base
  layout 'email'
  default from: "from@example.com"

  def new_comment(comment)
    @comment = comment
    mail to: comment.recipient.email, subject: "#{comment.user.name} commented on #{comment.bid.review_request.title}"
  end
end
