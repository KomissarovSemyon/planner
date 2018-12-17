# frozen_string_literal: true

class Meeting < ApplicationRecord
  validate :normal_date?
  belongs_to :user
  has_many :comments, dependent: :destroy

  private

  def normal_date?
    if start_time > end_time
      errors.add(:end_time, 'start time must be before end time')
      errors.add(:start_time, 'start time must be before end time')
    end
    errors.add(:start_time, 'start time must be after now') if start_time < Time.now
  end
end
