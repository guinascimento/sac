class Notifier < ActionMailer::Base

  default_url_options[:host] = 'localhost'

  def owner_alert(ticket, owner_email)
    subject       "O chamado ##{ticket.id} foi encaminhado para voce."
    from          "javaplayer@gmail.com"
    recipients    owner_email
    sent_on       Time.now
    body          :ticket => ticket
  end

end