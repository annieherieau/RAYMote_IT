class AttendancesController < ApplicationController
  before_action :authenticate_admin!
    def create
      @attendance = Attendance.new(user_id: current_user.id, workshop_id: params[:workshop_id])
  
      if @attendance.save
        redirect_to Workshop.find(params[:workshop_id]), notice: 'Vous vous êtes inscrit à cet atelier avec succès.'
      else
        redirect_to Workshop.find(params[:workshop_id]), alert: 'Échec de l\'inscription à cet atelier.'
      end
    end
  
    def destroy
        @attendance = Attendance.find(params[:id])
        @attendance.destroy
        redirect_to @attendance.workshop, notice: 'Vous vous êtes désinscrit avec succès de cet atelier.'
      end
  end
  