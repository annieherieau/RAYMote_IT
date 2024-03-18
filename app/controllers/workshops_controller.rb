class WorkshopsController < ApplicationController
  before_action :set_workshop, only: %i[ show edit update destroy ]

  # GET /workshops or /workshops.json
  def index
    @workshops = Workshop.all
  end

  # GET /workshops/1 or /workshops/1.json
  def show
    @workshop = Workshop.find(params[:id])
  end

  # GET /workshops/new
  def new
    @workshop = Workshop.new
  end

  # GET /workshops/1/edit
  def edit
  end

  # POST /workshops or /workshops.json
  def create
    workshop_params_mod = workshop_params
  workshop_params_mod[:start_date] = Date.strptime(workshop_params[:start_date], '%Y-%m-%d') rescue nil
  @workshop = Workshop.new(workshop_params_mod)

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
    respond_to do |format|
      if @workshop.update(workshop_params)
        format.html { redirect_to workshop_url(@workshop), notice: "Workshop was successfully updated." }
        format.json { render :show, status: :ok, location: @workshop }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @workshop.errors, status: :unprocessable_entity }
      end
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
  
  def register
    @workshop = Workshop.find(params[:id])
    @attendance = Attendance.new(user_id: current_user.id, workshop_id: @workshop.id)

    if @attendance.save
      redirect_to @workshop, notice: 'You have successfully registered for the workshop.'
    else
      redirect_to @workshop, alert: 'Failed to register for the workshop.'
    end
  end

  def manage
    @workshop = Workshop.find(params[:id])
    @attendances = @workshop.attendances
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workshop
      @workshop = Workshop.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def workshop_params
      params.require(:workshop).permit(:name, :description, :start_date, :duration, :price)
    end
end
