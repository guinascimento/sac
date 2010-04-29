Incident.transaction do
   Incident.seed_many(:id, [
     { :name => "Solicitação", :id => 1},
     { :name => "Problema",    :id => 2},
     { :name => "Informação",  :id => 3},
     { :name => "Reclamação",  :id => 4},
     { :name => "Sugestão",    :id => 5},
     { :name => "Elogio",      :id => 6}
])
end