class WorkshopsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_workshop, except: %i[ index new create ]
  before_action :authorize_creator!, only: %i[ edit update activate destroy ]
  before_action  :check_admin, only: [:validate]
  
  # GET /workshops or /workshops.json
  def index
    @top_categories = Category.left_joins(:workshops).group(:id).order('COUNT(workshops.id) DESC').limit(4)
  
    @workshops = Workshop.where(validated: true, brouillon: false).to_a.select do |workshop|
      workshop.status == 'en cours' || workshop.status == 'à venir'
    end
  end

  # GET /workshops/1 or /workshops/1.json
  def show
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
    @workshop.update(brouillon: !@workshop.brouillon, validated: false)
    if @workshop.save
      redirect_to request.referer || root_path, notice: "Mise à jour effectuée."
    end
    
  end

  # GET /workshops/1/edit
  def edit
    @categories = Category.all
    @tags = Tag.all
  end

  def validate
    @workshop.update(validated: true, brouillon: false)
    if @workshop.save
      redirect_to request.referer || root_path, notice: "Mise à jour effectuée."
    end
  end

  def refuse
    @workshop.update(brouillon: true)
    Message.create!(
      body: "Désolé, votre atelier n'a pas été validé, car il ne respecte pas la charte des créateurs.",
      sender: current_admin, # ou nil si vous ne voulez pas spécifier d'expéditeur
      receiver: @workshop.creator,
      inbox: @workshop.creator.inbox
    )
    if @workshop.save
      redirect_to request.referer || root_path, notice: "Mise à jour effectuée."
    end
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
      params.require(:workshop).permit(:name, :description, :start_date, :duration, :price, :category_id, :validated, :brouillon, tag_ids: [])
    end

end
