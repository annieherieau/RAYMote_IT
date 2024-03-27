class DynamicPagesController < ApplicationController

  # Page d'accueil
  def home
    @top_categories = Category.left_joins(:workshops).group(:id).order('COUNT(workshops.id) DESC').limit(8)
    @workshops = Workshop.where(validated: true, brouillon: false).to_a.select do |workshop|
      workshop.status == 'en cours' || workshop.status == 'à venir'
    end
  end
end
