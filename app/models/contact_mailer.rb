class ContactMailer < ActionMailer::Base
  def contact(post)
    @subject = '[travisonrails.com] New comment posted'
    @body['post'] = post
    @recipients = 'traviskroberts@gmail.com'
    @from = 'comments@travisonrails.com'
    @sent_on = Time.now
    @headers    = {}
  end
end
