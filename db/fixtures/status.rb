Status.transaction do
   Status.seed_many(:id, [
     { :name => "Novo",                   :id => 1},
     { :name => "Em andamento",           :id => 2},
     { :name => "Pendente com o cliente", :id => 3},
     { :name => "Finalizado",             :id => 4},
     { :name => "Cancelado",              :id => 5}
])
end