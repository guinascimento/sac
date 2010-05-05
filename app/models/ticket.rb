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
  named_scope :not_closed, :joins => :status, :conditions => [ "statuses.name <> ? AND owned_by = ?", "Finalizado", 1 ]
  named_scope :recently_assigned_to, lambda { | user_id | { :limit => 5, :conditions => { :owned_by => user_id }, :include => [:creator, :owner, :group, :status, :priority, :contact], :order => ['updated_at DESC']} }
  named_scope :active_tickets, :limit => 5, :include => [:creator, :owner, :category, :status, :incident], :order => ['updated_at DESC']
  named_scope :closed_tickets, :limit => 5, :joins => :status, :include => [:creator, :owner, :category, :status, :incident], :conditions => [ "statuses.name = ? AND owned_by = ?", "Finalizado", 1 ], :order => ['closed_at DESC']

  def closed?
    status.name == 'Finalizado'
  end  

  def has_owner?
    owner != nil
  end

  protected

    def set_closed_at
      # update the closed_at timestamp if the ticket is being closed
      if closed?        
        self.closed_at = DateTime.now if self.closed_at.nil?
      else
        self.closed_at = nil unless self.closed_at.nil?
      end
    end

end