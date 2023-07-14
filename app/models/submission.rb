class Submission < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  scope :this_week, -> { where('updated_at >= ?', DateRange.beginning_of_this_week) }
  scope :last_week, -> { where('updated_at >= ? AND updated_at < ?', DateRange.beginning_of_this_week - 1.week, DateRange.beginning_of_this_week) }
  scope :week_before_last_week, -> { where('updated_at >= ? AND updated_at < ?', DateRange.beginning_of_this_week - 2.week, DateRange.beginning_of_this_week - 1.week) }
  scope :except_this_week, -> { where('updated_at < ?', DateRange.beginning_of_this_week) }
  scope :ordered_by_most_recent, -> { order(updated_at: :desc) }

  def display_title
    title.present? ? title : 'Untitled'
  end

  def this_weeks_submission?
    created_at >= DateRange.beginning_of_this_week
  end

  def topic
    Topic.from_week_of(updated_at) || Topic.current
  end

  def next
    Submission.except_this_week.where('updated_at > ?', updated_at).ordered_by_most_recent.first
  end

  def previous
    Submission.except_this_week.where('updated_at < ?', updated_at).ordered_by_most_recent.first
  end
end
