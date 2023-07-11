module SubmissionsHelper
  def next_sunday_at_midnight
    now = Time.zone.now.end_of_week
    next_sunday = now.end_of_week
    next_sunday_at_midnight = next_sunday.change(hour: 0)
    if now > next_sunday_at_midnight
      next_sunday_at_midnight = (next_sunday + 1.week).change(hour: 0)
    end
    next_sunday_at_midnight
  end
  
  def last_sunday_at_midnight
    now = Time.zone.now.end_of_week
    last_sunday = now.beginning_of_week
    last_sunday_at_midnight = (last_sunday - 1.minute)
    if now < last_sunday_at_midnight
      last_sunday_at_midnight = (last_sunday - 1.week).change(hour: 0)
    end
    last_sunday_at_midnight
  end

  def before_last_sunday_at_midnight
    last_sunday_at_midnight - 1.week
  end

  def time_until_next_sunday
    distance_of_time_in_words(Time.now, next_sunday_at_midnight)
  end

end
