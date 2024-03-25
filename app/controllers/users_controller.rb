class UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update destroy become_creator ]
  before_action  :check_admin, only: [:promote_to_creator]
  before_action :authenticate_user!, except: [:promote_to_creator, :deny_creator]
  before_action :authenticate_admin!, only: [ :promote_to_creator, :deny_creator ]


  # GET /profile/1
  def show
    @user = User.find(params[:id])
    if (current_user == @user || @user.creator)
      @workshops = Workshop.all
      @created_workshops = @user.created_workshops
      @draft_workshops = @user.created_workshops.where(validated: true)
    else
      redirect_to user_path(current_user)
    end

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
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
      
    end
    redirect_to root_path
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
  
    current_user.update(pending: true)
    redirect_to user_path(current_user), notice: 'Votre demande a été envoyée à tous les administrateurs.'
  end

  def promote_to_creator
    user = User.find(params[:user_id])
    user.update(creator: true)
    user.update(pending: false)
    Message.create!(
      body: "Félicitations ! Vous avez été accepté en tant que créateur.",
      sender: current_admin, # ou nil si vous ne voulez pas spécifier d'expéditeur
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
