class Submission < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  scope :this_week, -> { where('created_at >= ?', Time.zone.now.beginning_of_week) }
end
