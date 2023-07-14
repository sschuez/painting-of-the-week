class WorkerController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def create_new_topic
    previous_topics = Topic.all.map(&:title)
    TopicJob.perform_later(previous_topics)

    head :ok
    logger.debug "🔥 Added job to create new topic"
  end
end