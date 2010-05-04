class TicketObserver < ActiveRecord::Observer

  def after_save(ticket)
    # send alert to the owner of the ticket
    if ticket.owned_by_changed? and !ticket.owned_by.nil?
      Notifier.deliver_owner_alert(ticket, ticket.owner.email)
    end
  end
end