class Submission < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  scope :this_week, -> { where('created_at >= ?', Time.zone.now.beginning_of_week) }
  scope :last_week, -> { where('created_at >= ? AND created_at < ?', Time.zone.now.beginning_of_week - 1.week, Time.zone.now.beginning_of_week) }
  scope :week_before_last_week, -> { where('created_at >= ? AND created_at < ?', Time.zone.now.beginning_of_week - 2.week, Time.zone.now.beginning_of_week - 1.week) }
end
