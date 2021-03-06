# Representation of non-monetary assistance coordinated for a patient.
class PracticalSupport < ApplicationRecord
  # Concerns
  include PaperTrailable

  # Relationships
  belongs_to :can_support, polymorphic: true

  # Validations
  validates :source, :support_type, presence: true
  validates :support_type, uniqueness: { scope: :can_support }
end
