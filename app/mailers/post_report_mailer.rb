class PostReportMailer < ApplicationMailer

  def post_report(user, post, post_report)
    mail to: user.email, subject: "Post Report: #{post.title}"
  end
end
