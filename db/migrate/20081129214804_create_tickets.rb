class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.string :subject, :null => false
      t.text :message
      t.references :category, :null => false
      t.references :status, :null => false
      t.references :incident, :null => false
      t.integer :created_by, :null => false
      t.integer :owned_by
      t.datetime :closed_at
      t.integer :comments_count, :default => 0 #counter cache field
      t.timestamps
    end

    add_index :tickets, :category_id
    add_index :tickets, :status_id
    add_index :tickets, :incident_id
    add_index :tickets, :created_by
    add_index :tickets, :owned_by
  end

  def self.down
    drop_table :tickets
  end
end
