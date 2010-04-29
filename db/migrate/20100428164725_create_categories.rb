class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name, :null => false
    end

    ["Concursos", "Provas", "Questões", "Denúncia", "Dúvidas", "Financeiro", "Sugestões", "Suporte Técnico"].each do |c|
      Category.create(:name => c)
    end
  end

  def self.down
    drop_table :groups
  end
end