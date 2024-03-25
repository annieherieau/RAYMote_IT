class WorkshopsController < ApplicationController
  before_action :authenticate_user!, only: %i[ new create edit update destroy ]
  before_action :set_workshop, only: %i[ show edit update destroy ]
  before_action :authorize_creator!, only: %i[ edit update destroy ]
  before_action  :check_admin, only: [:validate]
  
  # GET /workshops or /workshops.json
  def index
    @workshops = Workshop.where(validated: true, brouillon: false).to_a.select do |workshop|
      workshop.status == 'en cours' || workshop.status == 'à venir'
    end
  end

  # GET /workshops/1 or /workshops/1.json
  def show
    @workshop = Workshop.find(params[:id])
    @attendances = @workshop.attendances || []
    @category = @workshop.category
    @status = @workshop.status
  end

  # GET /workshops/new
  def new
    @workshop = Workshop.new
    @categories = Category.all
    @tags = Tag.all
    
  end

  def activate
    @workshop = Workshop.find(params[:id])
    draft = !@workshop.brouillon
    @workshop.update_attribute(:brouillon, !@workshop.brouillon, validated: false)
    redirect_to request.referer || root_path, notice: "L'atelier a été activé."
  end

  # GET /workshops/1/edit
  def edit
    @workshop = Workshop.find(params[:id])
    @categories = Category.all
    @tags = Tag.all
  end

  def validate
    workshop = Workshop.find(params[:id])
    workshop.update(validated: true)
    redirect_back(fallback_location: root_path, notice: 'Workshop validé avec succès.')
  end

  # POST /workshops or /workshops.json
  def create
    workshop_params_mod = workshop_params
    workshop_params_mod[:start_date] = Date.strptime(workshop_params[:start_date], '%Y-%m-%d') rescue nil
    @workshop = Workshop.new(workshop_params_mod)
    @workshop.creator = current_user
    @tags = Tag.all
    @categories = Category.all
  
    respond_to do |format|
      if @workshop.save
        format.html { redirect_to workshop_url(@workshop), notice: "Workshop was successfully created." }
        format.json { render :show, status: :created, location: @workshop }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @workshop.errors, status: :unprocessable_entity }
      end
    end
  end
  
  

  # PATCH/PUT /workshops/1 or /workshops/1.json
  def update
    @workshop = Workshop.find(params[:id])

  # Supprimez les tags marqués pour suppression
  if params[:workshop][:deleted_tag_ids].present?
    deleted_tag_ids = params[:workshop][:deleted_tag_ids].reject(&:blank?).map(&:to_i)
    @workshop.tags.delete(Tag.where(id: deleted_tag_ids))
  end

  # Continuez avec la mise à jour des tags existants et des nouveaux tags comme précédemment
  if params[:workshop][:tag_names].present?
    params[:workshop][:tag_names].each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      @workshop.tags << tag unless @workshop.tags.include?(tag)
    end
  end

  # Finalement, mettez à jour le workshop avec les autres paramètres
  if @workshop.update(workshop_params)
    redirect_to workshop_url(@workshop), notice: "Workshop was successfully updated."
  else
    render :edit, status: :unprocessable_entity
  end
  end

  # DELETE /workshops/1 or /workshops/1.json
  def destroy
    @workshop.destroy!

    respond_to do |format|
      format.html { redirect_to workshops_url, notice: "Workshop was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  # Other methods...

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workshop
      @workshop = Workshop.find(params[:id])
    end

    def authorize_creator!
      unless (@workshop.creator == current_user) || current_admin
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to root_path
      end
    end

    # Only allow a list of trusted parameters through.
    def workshop_params
      params.require(:workshop).permit(:name, :description, :start_date, :duration, :price, :category_id, tag_ids: [])
    end

end
