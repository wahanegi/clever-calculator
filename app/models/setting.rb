class Setting < ApplicationRecord
  has_one_attached :logo

  validate :validate_singleton_instance

  # Returns the singleton setting instance, creates it if it doesn't exist
  def self.current
    first_or_create!
  end

  private

  def validate_singleton_instance
    return unless Setting.where.not(id: id).exists?

    errors.add(:base, "Only one setting instance is allowed.")
  end
end
