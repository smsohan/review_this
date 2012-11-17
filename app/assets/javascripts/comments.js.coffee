class CommentForm
  constructor: (@form, @commentsContainer)->
    @form.on 'ajax:success', (evt, html, status, xhr) =>
      @addNewComment(html)
      @form[0].reset()

  addNewComment: (html)->
    @commentsContainer.prepend(html)


@CommentForm = CommentForm