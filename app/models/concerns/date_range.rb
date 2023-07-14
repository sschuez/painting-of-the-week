class DateRange < ActiveRecord::Base
  def self.current_week_range
    Date.today.beginning_of_week.to_time(:utc)..Date.today.end_of_week.to_time(:utc)
  end

  def self.current_week_range_in_words
    "#{Date.today.beginning_of_week.to_time(:utc).strftime("%B %d")} - #{Date.today.end_of_week.to_time(:utc).strftime("%B %d")}"
  end

  def self.current_week_range_in_words
    "#{Date.today.beginning_of_week.strftime("%B %d")} - #{Date.today.end_of_week.strftime("%B %d")}"
  end

  def self.end_of_this_week
    Date.today.end_of_week.to_time(:utc)
  end

  def self.beginning_of_this_week
    Date.today.beginning_of_week.to_time(:utc)
  end

  def self.time_left_until_end_of_this_week
    DateRange.end_of_this_week - Time.now
  end

  def self.week_range_in_words_for(date)
    "#{date.beginning_of_week.strftime("%B %d")} - #{date.end_of_week.strftime("%B %d")}"
  end

  def self.week_range_for(date)
    date.beginning_of_week..date.end_of_week
  end
end