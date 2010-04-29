class CommentsController < ApplicationController

  def create
    @ticket = Ticket.find(params[:ticket_id])
    @comment = @ticket.comments.build(params[:comment])

    # GET CURRENT_USER FROM SESSION
    current_user = User.create!(:first_name => "Guilherme", :last_name => "Nascimento", :email => "javaplayer@gmail.com")
    @comment.user_id = current_user.id

    redirect_to(@ticket) and return if @comment.comment.blank?

    if params[:close_ticket]
      status = Status.find(:first, :conditions => "name = 'Closed'")
      @ticket.update_attribute(:status_id, status.id)
      @comment.comment = "<strong>Status</strong> changed to closed<br/>" + @comment.comment
    end

    respond_to do |format|
      if @comment.save
        flash[:success] = 'Resposta adicionada com sucesso.'
        format.html { redirect_to(@ticket) }
        format.xml { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render 'tickets/show' }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end    
  end

  def destroy
    comment = Comment.find(params[:id])
    ticket_id = comment.ticket_id
    comment.destroy

    respond_to do |format|
      flash[:success] = 'Comment was successfully deleted!'
      format.html { redirect_to(ticket_path(ticket_id)) }
      format.xml  { head :ok }
    end
  end

  private

  def set_current_tab
    @current_tab = :tickets
  end
end
