class Task < ApplicationRecord
  belongs_to :project
  has_one_attached :file
  validates :status, inclusion: { in: %w[not-started in-progress complete] }

  FILE_VALIDATIONS = {
    content_types: ['text/csv']

  }.freeze
  STATUS_OPTIONS = [
    ['Not Started', 'not-started'],
    ['In Progress', 'in-progress'],
    %w[Complete complete]
  ].freeze

  def self.import(file, project)
    correct_header = %w[name description status]
    header_from_file = CSV.foreach(file.path).first.map(&:downcase)
    
  #   begin
  #   if header_from_file == correct_header
  #     CSV.foreach(file.path, headers: true, row_sep: :auto, col_sep: ',', header_converters: :symbol) do |row|
  #       if row[:status] == '0'
  #         row[:status] = 'not-started'
  #       elsif row[:status] == '1'
  #         row[:status] = 'in-progress'
  #       elsif row[:status] == '2'
  #         row[:status] = 'complete'
  #       end
  #       project.tasks.create! row.to_hash
  #     end
  # end
  #   rescue CSV::MalformedCSVError => er
  #     puts 'CSV file is not formatted correctly. Please regenerate CSV file'
  #     return false
  # end
end

  def self.to_csv
    header_attributes = %w[Name Description Status]
    CSV.generate(headers: true) do |csv|
      csv << header_attributes
      all.each do |item|
        csv << item.attributes.values_at('name', 'description', 'status')
      end
    end
  end

  def badge_color
    case status
    when 'not-started'
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

def validate_csv_file
  
end
