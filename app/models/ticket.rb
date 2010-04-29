class Ticket < ActiveRecord::Base

  # Associations
  belongs_to :category
  belongs_to :status
  belongs_to :incident
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by"
  belongs_to :owner, :class_name => "User", :foreign_key => "owned_by"
  has_many :comments, :dependent => :destroy
  has_many :attachments, :dependent => :destroy, :class_name => '::Attachment'
  has_many :alerts, :dependent => :destroy
  has_many :alert_users, :through => :alerts, :class_name => 'User', :source => :user

  # Validations
  validates_presence_of :subject, :message, :category_id, :incident_id

  # Callbacks
  before_update :set_closed_at

  # Scopes
  named_scope :not_closed, :joins => :status, :conditions => ['statuses.name <> ?', 'Finalizado']
  named_scope :recently_assigned_to, lambda { | user_id | { :limit => 5, :conditions => { :owned_by => user_id }, :include => [:creator, :owner, :group, :status, :priority, :contact], :order => ['updated_at DESC']} }
  named_scope :active_tickets, :limit => 5, :include => [:creator, :owner, :category, :status, :incident], :order => ['updated_at DESC']
  named_scope :closed_tickets, :limit => 5, :joins => :status, :include => [:creator, :owner, :category, :status, :incident], :conditions => ['statuses.name = ?', 'Finalizado'], :order => ['closed_at DESC']

  def self.timeline_opened_tickets(from_date, to_date)
    self.count(:group => 'date(created_at)', :having => ['date_created_at >= ? and date_created_at < ?', from_date, to_date], :order => 'date_created_at')
  end

  def self.timeline_closed_tickets(from_date, to_date)
    self.count(:group => 'date(closed_at)', :having => ['date_closed_at >= ? and date_closed_at < ?', from_date, to_date], :order => 'date_closed_at')
  end

  def closed?
    status.name == 'Finalizado'
  end

  def only_touched?
    self.changed.size == 1 and self.changed[0] == "updated_at"
  end

  protected

  def set_closed_at
    # update the closed_at timestamp if the ticket is being closed
    if closed?
      logger.info("Ticket is being closed!")
      self.closed_at = DateTime.now if self.closed_at.nil?
    else
      self.closed_at = nil unless self.closed_at.nil?
    end
  end

end
