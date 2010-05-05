Given /^the following tickets:$/ do |tickets|
  Ticket.create!(tickets.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) ticket$/ do |pos|
  visit tickets_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following tickets:$/ do |expected_tickets_table|
  expected_tickets_table.diff!(tableish('table tr', 'td,th'))
end

Given /^there are open tickets:$/ do |table|
  current_user = User.create!(:first_name => "Guilherme", :last_name => "Nascimento", :email => "javaplayer@gmail.com")

  table.hashes.each do |hash|
    category = Category.create!(:name => hash[:category])
    incident = Incident.create!(:name => hash[:incident])
    status = Status.create!(:name => hash[:status])

    Ticket.create!(:subject => hash[:subject], :category => category, :incident => incident, :status => status, :message => hash[:message], :creator => current_user, :owner => current_user)    
  end
end

Given /^there are closed tickets:$/ do |table|
  current_user = User.create!(:first_name => "Guilhermedddd", :last_name => "Nascimento", :email => "javaplayer@gmail.com")

  table.hashes.each do |hash|
    category = Category.create!(:name => hash[:category])
    incident = Incident.create!(:name => hash[:incident])
    status = Status.create!(:name => hash[:status])

    Ticket.create!(:subject => hash[:subject], :category => category, :incident => incident, :status => status, :message => hash[:message], :creator => current_user, :owner => current_user)
  end
end