class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.timestamps
    end
    add_column :users, :email, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :equipe, :integer
    
    User.create!(:first_name => "Joana", :last_name => "Atendente", :email => "joao@questoesdeconcursos.com.br", :equipe => 1)      
    User.create!(:first_name => "Marcos", :last_name => "Desenvolvimento", :email => "marcos@questoesdeconcursos.com.br", :equipe => 1)      
    User.create!(:first_name => "Carla", :last_name => "Financeiro", :email => "carla@questoesdeconcursos.com.br", :equipe => 1)      
  end

  def self.down
    drop_table :users
  end
end