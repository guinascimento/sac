class TicketsController < ApplicationController
  before_filter :lookup_ticket, :only => [:edit, :update, :destroy]

  def index
    @tickets_per_page = tickets_per_page
    @search = Ticket.search(params[:search])
    @closed_status = Status.find(:first, :select => 'id', :conditions => "name = 'Finalizado'")
    @open_status = Status.find(:first, :select => 'id', :conditions => "name = 'Novo'")

    if params[:search]
      if !params[:search][:created_at_gte].blank?
        start_date = Date.strptime(params[:search][:created_at_gte],"%Y-%m-%d")
        @search.created_at_gte = start_date
        start_date = start_date.midnight.gmtime
        params[:search][:created_at_gte] = start_date.midnight
      end
      if !params[:search][:created_at_lt].blank?
        end_date = Date.strptime(params[:search][:created_at_lt],"%Y-%m-%d")
        @search.created_at_lt = end_date
        end_date = end_date.next.midnight.gmtime
        params[:search][:created_at_lt] = end_date.midnight
      end
      @tickets = Ticket.search(params[:search]).paginate(
        :page => params[:page],
        :include => [:creator, :owner, :category, :status, :incident],
        :order => 'updated_at DESC',
        :per_page => @tickets_per_page)
    else
      @tickets = Ticket.all.paginate(
        :page => params[:page],
        :include => [:creator, :owner, :category, :status, :incident],
        :order => 'updated_at DESC',
        :per_page => @tickets_per_page)
    end

    @total_tickets = @tickets.total_entries

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.xml  { render :xml => @tickets }
    end
  end

  def show
    begin
      @ticket = Ticket.find(params[:id], :include => { :comments => :user })
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid ticket_id => #{params[:id]}")
      flash[:error] = "You have requested an invalid ticket!"
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
    current_user = User.create!(:first_name => "Guilherme", :last_name => "Nascimento", :email => "javaplayer@gmail.com")
    @ticket.creator = current_user

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

  # Sets a cookie on the user's browser to indicate the tickets per page value
  def set_tickets_per_page
    @per_page = params[:per_page]
    cookies[:tickets_per_page] = { :value => "#{@per_page}", :expires => 1.year.from_now }
    flash[:success] = "You are now viewing #{@per_page} tickets per page!"
    redirect_to tickets_path
  end

  private

  def lookup_ticket
    begin
      @ticket = Ticket.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid ticket_id => #{params[:id]}")
      flash[:error] = "You have requested an invalid ticket!"
      redirect_to tickets_path and return
    end
  end

  def set_current_tab
    @current_tab = :tickets
  end

end
