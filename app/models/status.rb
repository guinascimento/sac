class Status < ActiveRecord::Base

  # Associations
  has_many :tickets

  # Scopes
  named_scope :enabled, :order => 'name', :conditions => { :disabled_at => nil }
  named_scope :disabled, :order => 'name', :conditions => ['disabled_at IS NOT NULL']

  # Validations
  validates_presence_of :name  

  def enabled?
    disabled_at.blank?
  end

end