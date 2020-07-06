class Task < ApplicationRecord
  belongs_to :project
  has_one_attached :file 
  validate :correct_file_type
  
  def correct_file_type
    if (file.attached? && !file.content_type.in?(%w(text/csv text/plain)))
      file.purge # delete the uploaded file
      errors.add(:file, 'Must be a CSV file')
    end
  end

  def self.import(file)

    #PATH LOCATION OF FILE FOR ACTIVE STORAGE
    file_path = ActiveStorage::Blob.service.send(:path_for, file.pathmap)

    # @tasks = Task.project.create(name: "TEST SAVE", id: Task.project.id, desscription: "TEST SAVE")
    #BROKEN, why is project nil? How do I get to project
    # @tasks = self.project.create()
    # @task.save
    #BROKEN
    # CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      # Project.tasks.create! row.to_hash
    # end
  end
  

  validates :status, inclusion: {in: ['not-started', 'in-progress', 'complete']}

  STATUS_OPTIONS = [
    ['Not Started', 'not-started'],
    ['In Progress', 'in-progress'],
    ['Complete', 'complete']
  ]

  has_one_attached :file 
  validate :correct_file_type
  


  def self.to_csv
    header_attributes = %w{ Name Description Status }
    CSV.generate( headers: true ) do |csv|
      csv << header_attributes
      all.each do |item|
        csv << item.attributes.values_at("name", "description", "status")
      end
    end
  end

  def badge_color
    case status
    when'not-started'
      'secondary'
    when 'in-progress'
      'info'
    when 'complete'
      'success'
    end
  end
  def complete?
    status ==  'complete'
  end
  def not_started?
    status ==  'not-started'
  end
  def in_progress?
    status ==  'in-progress'
  end
end
