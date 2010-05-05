class DashboardController < ApplicationController

  def index
    @active_tickets = Ticket.not_closed.active_tickets
    @closed_tickets = Ticket.closed_tickets
  end

end