class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy become_creator]
  before_action :authenticate_admin!, only: [:destroy, :promote_to_creator, :deny_creator]
  before_action :authenticate_user!, except: [:promote_to_creator, :deny_creator, :destroy, :public]
  

  # GET /profile/1
  def show
    @user = User.find(params[:id])
    redirect_to user_path(current_user) if (current_user != @user)
    
    @accessibility_settings = current_user.setting
    @workshops = Workshop.all
    @validated_workshops = @user.created_workshops.where(brouillon: false)
    @draft_workshops = @user.created_workshops.where(brouillon: true)
    @received_messages = Message.where(receiver: @user)
    @sent_messages = Message.where(sender: @user)

  end

  # PATCH/PUT /profile/1
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "Vos informations ont été enregistrées." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profile/1
  def destroy
    @user = User.find(params[:id])
    if !@user.creator
      @user.destroy
      flash[:notice] = "L'utilisateur a été supprimé avec succès."
    else
       @user.created_workshops.each do |workshop|
        if workshop.users.any?
          workshop.update_attribute(:creator_id, 1)
        else
          workshop.destroy
       end
      end
      @user.destroy
      flash[:alert] = "Créateur supprimé. "
    end
  
    redirect_to dashboard_path
  end


  # validation de la demande de compte creator
  def validate
    @user = User.find(params[:id])
    if @user.update(creator: true)
      notice = "Utilisateur validé comme Creator."
    else
      alert = "Une erreur s'est produite: Utilisateur non validé."
    end
    redirect_back(fallback_location: root_path, notice: notice)
  end

  def become_creator
    message_content = params[:message]
    Admin.find_each do |admin|
      admin.inbox.messages.create!(
        body: message_content,
        sender: current_user,
        receiver: admin
      )
    end
    current_user.update_attribute(:pending, true)
    redirect_to user_path(current_user), notice: 'Votre demande a été envoyée à tous les administrateurs.'
  end

  def promote_to_creator
    user = User.find(params[:user_id])
    user.update_attribute(:creator, true)
    user.update_attribute(:pending, false)
    Message.create!(
      body: "Félicitations ! Vous avez été accepté en tant que créateur.",
      sender: current_admin,
      receiver: user,
      inbox: user.inbox
    )
    redirect_to dashboard_path, notice: "#{user.email} a été promu en tant que créateur."
  end

  def deny_creator
    user = User.find(params[:user_id])
    user.update(pending: false)
    Message.create!(
      body: "Votre demande pour devenir créateur a été refusée.",
      sender: current_admin,
      receiver: user,
      inbox: user.inbox
    )
    redirect_to dashboard_path, notice: "#{user.email} a été promu en tant que créateur."
  end

  def public
    @user = User.find(params[:id])
    unless @user.creator
      redirect_to request.referer || root_path
    end
    @published_workshops = @user.created_workshops.where(validated: true)
    @total_attendances = 0
    @categories = []
    @published_workshops.each do |workshop|
      @total_attendances += workshop.users.count
      @categories << workshop.category
    end
    

  end
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :creator, :avatar)
  end
end
