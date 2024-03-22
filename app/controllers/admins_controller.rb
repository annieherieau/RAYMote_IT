class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def dashboard
    @users = User.all
    @workshops = Workshop.all.where(brouillon: false)
    # atelier en attente de validation
    @workshops_to_validate = Workshop.where(validated: false, brouillon: false)
    @tags = Tag.all
    @categories = Category.all
    @reviews = Review.all
    @admin = current_admin
    @received_messages = @admin.received_messages
  end

end
