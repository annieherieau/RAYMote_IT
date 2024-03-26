class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def dashboard
    @users = User.all
    @workshops = Workshop.where(brouillon: false)
    @workshops_to_validate = Workshop.where(validated: false, brouillon: false)
    @tags = Tag.all
    @categories = Category.all
    @reviews = Review.all
    @admin = current_admin
    @received_messages = @admin.received_messages
  end

  def admin_notif
    message_content = params[:message]
    
    User.find_each do |user|
      user.inbox.messages.create!(
        body: message_content,
        sender: current_admin,
        receiver: user
      )
    end
    redirect_to dashboard_path
  end


  
end
