class TemplateController < ApplicationController

  def load_template
    template_dir = Rails.root + 'templates/'
    option = params[:name]

    if option == "Template 1"
      template = template_dir + "template1"
    elsif option == "Template 2"
      template = template_dir + "template2"
    end

    user = User.find_by_id(params[:id])

    text = Mustache.render(File.new(template).read, :name => user.full_name)
    render :inline => text
  end

end