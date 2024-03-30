class LikesController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  
    def create
      @workshop = Workshop.find(params[:workshop_id])
      workshop = Workshop.find(params[:workshop_id])
      workshop.likes.where(user: current_user).first_or_create
      unless current_user
        flash.now[:alert] = "Vous devez être connecté pour effectuer cette action."
        respond_to do |format|
          format.js { render 'likes/not_logged_in' }
        end
        return
      end
  
      
      respond_to do |format|
        format.html { redirect_to @workshop}
        format.js  
      end
    end
  
    def destroy
      @workshop = Workshop.find(params[:workshop_id])
      workshop = Workshop.find(params[:workshop_id])
      workshop.likes.where(user: current_user).destroy_all
  
      
      respond_to do |format|
        format.html { redirect_to @workshop }
        format.js  
      end
    end
  end