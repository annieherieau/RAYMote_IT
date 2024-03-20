class LikesController < ApplicationController
  before_action :authenticate_admin!
    before_action :authenticate_user!
  
    def create
      workshop = Workshop.find(params[:workshop_id])
      workshop.likes.where(user: current_user).first_or_create
  
      flash[:notice] = "Vous avez aimé cet atelier."
      redirect_to request.referer || root_path
    end
  
    def destroy
      workshop = Workshop.find(params[:workshop_id])
      workshop.likes.where(user: current_user).destroy_all
  
      flash[:notice] = "Vous n'aimez plus cet atelier."
      redirect_to request.referer || root_path
    end
  end