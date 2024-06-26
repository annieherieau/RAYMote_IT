class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]

  # GET /categories or /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  def show
    @workshops =  @category.workshops.where(event: true)
    @courses = @category.workshops.where(event: false)
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    @category.default_icon unless @category.icon.attached?
      if @category.save
        redirect_to category_path(@category) || root_path, notice: "La catégorie a été créée avec succès." 
      else
        render :new, status: :unprocessable_entity 
      end
  end

  # PATCH/PUT /categories/1
  def update
      if @category.update(category_params)
        redirect_to category_url(@category), notice: "La catégorie a été mise à jour avec succès."
      else
        render :edit, status: :unprocessable_entity
      end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy!
    redirect_to categories_url, notice: "La catégorie a été détruite avec succès."
  end


  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name, :icon)
    end
end
