class Topic < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

  scope :of_this_week, -> { where(created_at: DateRange.current_week_range) }
  
  def self.create_from_topic_creator(message)
    title = message.split("\n\n").first.gsub("Title: ", "")
    body = message.split("\n\n").last.gsub("Description: ", "")
    
    Topic.create!(title: title, body: body)
  end

  def self.current
    Topic.of_this_week.first || Topic.create!(title: "The Unseen Magic of Everyday Life", body: "Hello, my radiant creators! This week, we're going to step into the extraordinary world hidden within the ordinary. It's about those quiet, yet intensely beautiful moments we often overlook - the morning light filtering through the window, the steam rising from a mug of hot coffee, the gentle sway of clothes hanging on the line. Let's celebrate the unseen magic of everyday life and make it visible in our paintings! Let your brushes find beauty in the mundane and show the world that 'normal' can be quite extraordinary.")
  end

  def self.from_week_of(date)
    Topic.where(created_at: DateRange.week_range_for(date)).first
  end

end
