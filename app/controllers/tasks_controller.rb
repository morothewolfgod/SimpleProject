class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_task, only: %i[show edit update destroy]

  # GET projects/1/tasks
  def index
    @tasks = @project.tasks
  end

  def import
    if !params[:file].nil?
      if !Task::FILE_VALIDATIONS[:content_types].include? params[:file].content_type
        flash[:alert] = "ERROR: File uploaded was not a CSV file"
      else
        @project.tasks.import(params[:file], @project)
        correct_header = %w[name description status]
        header_from_file = CSV.foreach(params[:file].path).first.map(&:downcase)

        begin
        if header_from_file != correct_header
          flash[:alert] = "ERROR: The header information in the file needs to be Name, Description, Status"
        else
          CSV.foreach(params[:file].path, headers: true, row_sep: :auto, col_sep: ',', header_converters: :symbol) do |row|
            if row[:status] == '0'
              row[:status] = 'not-started'
            elsif row[:status] == '1'
              row[:status] = 'in-progress'
            elsif row[:status] == '2'
              row[:status] = 'complete'
            end
            project.tasks.create! row.to_hash
          end
      end
        rescue CSV::MalformedCSVError
          flash[:alert] = "ERROR: CSV file is not formatted correctly. Please regenerate CSV file"
      end
      end
    else
      flash[:alert] = "ERROR: No File was uploaded"
    end
    redirect_to(project_path(@project))
  end

  # GET projects/1/tasks/1
  def show; end

  # GET projects/1/tasks/new
  def new
    @task = @project.tasks.build
  end

  # GET projects/1/tasks/1/edit
  def edit; end

  # POST projects/1/tasks
  def create
    @task = @project.tasks.build(task_params)

    if @task.save
      redirect_to([@task.project])
    else
      render action: 'new'
    end
  end

  # PUT projects/1/tasks/1
  def update
    if @task.update_attributes(task_params)
      redirect_to([@task.project])
    else
      render action: 'edit'
    end
  end

  # DELETE projects/1/tasks/1
  def destroy
    @task.destroy

    redirect_to @project
  end

  def delete_all
    @project.tasks.destroy_all
    redirect_to @project
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def task_params
    params.require(:task).permit(:name, :description, :status, :project_id, :file)
  end
end
