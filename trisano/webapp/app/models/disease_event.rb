class DiseaseEvent < ActiveRecord::Base
  belongs_to :hospitalized, :class_name => 'ExternalCode'
  belongs_to :died, :class_name => 'ExternalCode'

  belongs_to :event
  belongs_to :disease

  validates_date :disease_onset_date, :allow_nil => true
  validates_date :date_diagnosed, :allow_nil => true

  def validate
    if !disease_onset_date.blank? && !date_diagnosed.blank?
      errors.add(:date_diagnosed, "cannot precede onset date") if date_diagnosed.to_date < disease_onset_date.to_date
    end
  end
end