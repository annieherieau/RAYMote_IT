class DynamicPagesController < ApplicationController

  # Page d'accueil
  def home
    #Créateurs d'ateliers
    @total_creator_users = User.where(creator: true).count

    #Etudiants non créateurs
    @total_non_creator_users = User.where(creator: false).count
            
    #cours suivis
    @courses = Workshop.where(event: false, validated: true).reverse.take(3)
    @events = Workshop.order('start_date').where(event: true, validated: true, start_date: DateTime.now...).take(2)
    @total_attendances = Attendance.count

    @top_categories = Category.left_joins(:workshops).group(:id).order('COUNT(workshops.id) DESC').limit(8)
    @workshops = Workshop.where(validated: true)

    @top_creators = User.where(creator: true).take(6)
  end
end