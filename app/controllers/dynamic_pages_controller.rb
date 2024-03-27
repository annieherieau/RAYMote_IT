class DynamicPagesController < ApplicationController

  # Page d'accueil
  def home
    #Créateurs d'ateliers
    @creator_users = User.joins(:workshops).distinct    
    @total_creator_users = @creator_users.count

    #Etudiants non créateurs
    @non_creator_users = User.where.not(id: Workshop.pluck(:creator_id).uniq)
    @total_non_creator_users = @non_creator_users.count
            
    #cours suivis
    @workshops = Workshop.all
    @total_attendances = 0
    @workshops.each do |workshop|
      @total_attendances += workshop.attendances.count

    @top_categories = Category.left_joins(:workshops).group(:id).order('COUNT(workshops.id) DESC').limit(8)
    @workshops = Workshop.where(validated: true, brouillon: false).to_a.select do |workshop|
      workshop.status == 'en cours' || workshop.status == 'à venir'

    end
  end
end
end