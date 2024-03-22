class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def dashboard
    @users = User.all
    @workshops = Workshop.all
    @pending_workshops = Workshop.where(validated: false)
    @tags = Tag.all
    @categories = Category.all
    @reviews = Review.all
  end

end
