class CourseItemsController < ApplicationController
    before_action :set_workshop
  
    def new
      @course_item = @workshop.course_items.build
    end
  
    def create
      @course_item = @workshop.course_items.build(course_item_params)
  
      if @course_item.save
        redirect_to @workshop, notice: 'Course item was successfully created.'
      else
        render :new
      end
    end
  
    private
  
    def set_workshop
      @workshop = Workshop.find(params[:workshop_id])
    end
  
    def course_item_params
      params.require(:course_item).permit(:link)
    end
  end