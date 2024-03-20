class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def show
    @users = User.all
    @workshops = Workshop.all
    @tags = Tag.all
    @categories = Category.all
    @reviews = Review.all
  end

  def destroy_user
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "L'utilisateur a été supprimé avec succès."
    redirect_to admin_dashboard_path
  end

end
