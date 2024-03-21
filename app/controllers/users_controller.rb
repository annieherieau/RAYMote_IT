class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action  :check_admin, only: [:validate]
  before_action :authenticate_user!, except: [:validate]
  before_action :authenticate_admin!, only: [:validate]


  # GET /profile/1
  def show
    @user = User.find(params[:id])
    @created_workshops = @user.created_workshops
  end

  # GET /profile/1/edit
  def edit
  end

  # PATCH/PUT /profile/1
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
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

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:firstname, :lastname, :email)
    end
end
