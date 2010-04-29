Category.transaction do
   Category.seed_many(:id, [
     { :name => "Concursos",       :id => 1},
     { :name => "Provas",          :id => 2},
     { :name => "Questões",        :id => 3},
     { :name => "Denúncia",        :id => 4},
     { :name => "Dúvidas",         :id => 5},
     { :name => "Financeiro",      :id => 6},
     { :name => "Sugestões",       :id => 7},
     { :name => "Suporte Técnico", :id => 8}
])
end