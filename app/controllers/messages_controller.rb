class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]


  # GET /messages or /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1 or /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
    @users = User.all
    @admins = Admin.all
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages or /messages.json
  def create
    # Initialisation du nouveau message avec les paramètres du message
    @message = Message.new(message_params)
    
    # Définition de l'expéditeur du message en fonction de l'utilisateur ou de l'administrateur actuellement connecté
    if current_admin
      @message.sender = current_admin
    elsif current_user
      @message.sender = current_user
    end
  
    # Récupération de l'Inbox du destinataire du message
    # Vous devez ajuster 'receiver_id' et 'receiver_type' en fonction de la manière dont vous transmettez ces informations
    if @message.receiver_type == "Admin"
      @inbox = Admin.find(@message.receiver_id).inbox
    elsif @message.receiver_type == "User"
      @inbox = User.find(@message.receiver_id).inbox
    end
  
    # Association du message à l'Inbox récupéré
    @message.inbox = @inbox
  
    respond_to do |format|
      if @message.save
        format.html { redirect_to message_url(@message), notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy!
    if current_admin
    redirect_to dashboard_path, notice: 'Message supprimé avec succès.'
    elsif current_user == @message.receiver
      redirect_to user_path(current_user), notice: 'Message supprimé avec succès.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:sender_id, :receiver_id, :body, :read)
    end
end
