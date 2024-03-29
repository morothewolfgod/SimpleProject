class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @task = @project.tasks.build
    @current_tasks = @project.tasks.offset(pagination).limit(2)
    
    
    respond_to do |format|
      format.html
      format.csv{send_data @project.tasks.to_csv,
      filename: @project.name + " Tasks.csv",
      type: 'text/csv; charset=utf-8' }
    end
  end

  # GET /projects/new
  def new
    @project = current_user.projects.build
  end

  # GET /projects/1/edit
  def edit
  end

  # def import
  #  @import_response =  current_user.projects.import(params[:file])
  # end
  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.build(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update

    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { redirect_to @project,  notice: 'Project was not successfully updated.' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
   
  private
    # Use callbacks to share common setup or constraints between actions.
    def project
      @project = current_user.projects.find(params[:id])
    end

    def pagination
      if params[:pagination]== nil || params[:pagination].to_i < 0
        @pagination = 0
      else
        @pagination = params[:pagination]
      end
    end
    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:name, :description)
    end   
end
