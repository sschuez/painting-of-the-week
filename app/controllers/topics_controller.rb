class TopicsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized

  def create
    previous_topics = Topic.all.map(&:title)
    TopicJob.perform_later(previous_topics)
  end
      
end