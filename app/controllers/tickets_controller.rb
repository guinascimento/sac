class TicketsController < ApplicationController

  def index    
    @search = Ticket.search(params[:search])
    @closed_status = Status.find(:first, :select => 'id', :conditions => "name = 'Finalizado'")
    @open_status = Status.find(:first, :select => 'id', :conditions => "name = 'Novo'")

    if params[:search]
      @tickets = Ticket.search(params[:search]).paginate(
        :page => params[:page],
        :include => [:creator, :owner, :category, :status, :incident],
        :order => 'updated_at DESC')
    else
      @tickets = Ticket.all.paginate(
        :page => params[:page],
        :include => [:creator, :owner, :category, :status, :incident],
        :order => 'updated_at DESC')
    end    

    respond_to do |format|
      format.html
    end
  end

  def show
    begin
      @ticket = Ticket.find(params[:id], :include => { :comments => :user })
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid ticket_id => #{params[:id]}")
      flash[:error] = "Você requisitou um ticket inválido!"
      redirect_to tickets_path and return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.pdf { render :layout => false }
      format.xml  { render :xml => @ticket }
    end
  end

  def new
    @ticket = Ticket.new

    # GET CURRENT_USER FROM SESSION
    current_user = User.create!(:first_name => "Guilherme", :last_name => "Nascimento", :email => "javaplayer@gmail.com")
    @ticket.creator = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ticket }
    end
  end

  def edit
    @owners = User.find_by_equipe(1)

    begin
      @ticket = Ticket.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid ticket_id => #{params[:id]}")
      flash[:error] = "Você tentou acessar um ticket inválido."
      redirect_to dashboard_path and return
    end
  end

  def create
    @ticket = Ticket.new(params[:ticket])

    # GET CURRENT_USER FROM SESSION
    default_owner = User.find(:first, :conditions => [ "first_name = ? AND equipe = ?", "Joana", 1 ])

    current_user = User.create!(:first_name => "Guilherme", :last_name => "Nascimento", :email => "javaplayer@gmail.com")
    @ticket.creator = current_user
    @ticket.owner = default_owner

    # setting initial status to open
    open = Status.find_by_name("Novo")
    @ticket.status = open

    respond_to do |format|
      if @ticket.save
        flash[:success] = "Ticket ##{@ticket.id} foi criado com sucesso."
        format.html { redirect_to(@ticket) }
        format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        flash[:success] = "Ticket ##{@ticket.id} foi atualizado com sucesso."
        format.html { redirect_to(@ticket) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to(tickets_url) }
      format.xml  { head :ok }
    end
  end

end