class CreateIncidents < ActiveRecord::Migration
  def self.up
    create_table :incidents do |t|
      t.string :name, :null => false
    end

    ["Solicitação", "Problema", "Informação", "Reclamação", "Sugestão", "Elogio"].each do |i|
      Incident.create(:name => i)
    end
  end

  def self.down
    drop_table :groups
  end
end