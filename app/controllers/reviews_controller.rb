class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]
  before_action :set_workshop, only: [:new, :create]
  before_action :authenticate_user!
  before_action :check_user, only: [:edit, :update, :destroy]



  # GET /reviews or /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1 or /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new(rating: params[:rating])
    @user = current_user
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews or /reviews.json
  def create
    @review = @workshop.reviews.build(review_params)
    @review.user = current_user

    respond_to do |format|
      if @review.save
        format.html { redirect_to @workshop, notice: "Votre avis a été enregistré avec succès" }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    @review = Review.find(params[:id])
    @workshop = @review.workshop
    respond_to do |format|
        if @review.update(review_params)
          format.html { redirect_to @workshop, notice: "L'avis a été mis à jour avec succès." }
          format.json { render :show, status: :created, location: @review }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @review.errors, status: :unprocessable_entity }
        end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review = Review.find(params[:id])
    @workshop = @review.workshop
    @review.destroy!

    respond_to do |format|
      format.html { redirect_to @workshop, notice: "Votre avis a été enregistré avec succès." }
          format.json { render :show, status: :created, location: @review }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:content, :rating)
    end

    def set_workshop
      @workshop = Workshop.find(params[:workshop_id])
    end

    def check_user
      if current_user != @review.user
        redirect_to root_url, alert: "Désolé, vous n'êtes pas autorisé à effectuer cette action"
      end
    end

end
