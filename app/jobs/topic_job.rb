class TopicJob < ApplicationJob
  queue_as :default

  def perform(previous_topics)
    topic = TopicCreator.call({ previous_topics: })

    if topic.success?
      @topic = Topic.create_from_topic_creator(topic.payload[:choices]['message']['content'])
      puts "🔥 Created topic: #{@topic.body}"
    else
      logger.error topic.error_message
      puts "🔥 Error ccreating topic: #{topic.error_message}"
    end
  end
end
