Feature: Manage tickets
  In order Manage a ticket
  As an atendent
  I want to create and edit a ticket

  Scenario: List all active tickets
    Given there are open tickets:
      | subject               | category  | incident   | status | message             |
      | Dúvida com pagamento  | Dúvidas   | Informação | Novo   | Quanto devo pagar ? |
      | Informações           | Dúvidas   | Elogio     | Novo   | Ótimo site.         |
    And I am on the dashboard page
    Then I should see "Tickets ativos"
    And I should see "1"
    And I should see "Dúvida com pagamento"

  Scenario: List all closed tickets
    Given there are closed tickets:
      | subject               | category  | incident   | status     | message             |
      | Dúvida com pagamento  | Dúvidas   | Informação | Finalizado | Quanto devo pagar ? |
      | Informações           | Dúvidas   | Elogio     | Finalizado | Ótimo site.         |
    And I am on the dashboard page
    Then I should see "Tickets finalizados"
    And I should see "1"
    And I should see "Dúvida com pagamento"

  Scenario: Create new ticket
    Given I am on the dashboard page
    And I press "Novo ticket"
    Then I should see "Guilherme Nascimento"
    And I should see "javaplayer@gmail.com"
    Then I fill in "Assunto" with "Dúvida"
    And I select "Dúvidas" from "Categoria"
    And I select "Problema" from "Incidente"
    And I fill in "Mensagem" with "Estou com uma dúvida em relação ao site."
    And I press "Criar"
    Then I should see "Ticket #1 foi criado com sucesso."

  Scenario: Edit a ticket
    Given there are open tickets:
      | subject               | category  | incident   | status | message             |
      | Dúvida com pagamento  | Dúvidas   | Informação | Novo   | Quanto devo pagar ? |
      | Informações           | Dúvidas   | Elogio     | Novo   | Ótimo site.         |
    And I am on the dashboard page
    Then I follow "Ticket #1"
    And I follow "Editar"
    And I fill in "Assunto" with "Prova melhorada"
    And I select "Provas" from "Categoria"
    And I select "Sugestão" from "Incidente"
    And I fill in "Mensagem" with "Gostaria de propor novas provas."
    And I press "Atualizar"
    Then I should see "Ticket #1 foi atualizado com sucesso."

    Scenario: Add a comment
      Given there are open tickets:
        | subject               | category  | incident   | status | message             |
        | Dúvida com pagamento  | Dúvidas   | Informação | Novo   | Quanto devo pagar ? |
        | Informações           | Dúvidas   | Elogio     | Novo   | Ótimo site.         |
      And I am on the dashboard page
      Then I follow "Ticket #1"
      And I follow "Responder"
      Then I fill in "Resposta" with "Você encontra os planos de pagamento no site."
      And I press "Adicionar"
      And I should see "Resposta adicionada com sucesso."