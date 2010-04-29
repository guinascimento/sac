class User < ActiveRecord::Base
  # Associations
  has_many :created_tickets, :class_name => "Ticket", :foreign_key => "created_by"
  has_many :opened_tickets, :class_name => "Ticket", :foreign_key => "opened_by"
  has_many :comments
  has_many :attachments
  has_many :alerts, :dependent => :destroy
  has_many :alert_tickets, :through => :alerts, :class_name => 'Ticket', :source => :ticket

  # Scopes
  named_scope :enabled, :order => 'username', :conditions => { :disabled_at => nil }

  attr_protected :admin

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def has_ticket_alert?(ticket_id)
    self.alert_tickets.each do |ticket|
      if ticket_id == ticket.id
        return true
      end
    end
    return false
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  def enabled?
    disabled_at.blank?
  end

end
