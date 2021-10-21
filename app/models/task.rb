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
