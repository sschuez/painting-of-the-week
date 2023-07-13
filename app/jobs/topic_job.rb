class TopicJob < ApplicationJob
  queue_as :default

  def perform(previous_topics)
    topic = TopicCreator.call({ previous_topics: previous_topics })

    if topic.success?
      title = topic.payload[:choices]["message"]["content"].split("\n\n").first.gsub("Title: ", "")
      body = topic.payload[:choices]["message"]["content"].split("\n\n").last.gsub("Description: ", "")
      
      @topic = Topic.create!(title: title, body: body)
      puts "🔥 Created topic: #{@topic.body}"
    else
      logger.error topic.error_message
      puts "🔥 Error creating topic: #{topic.error_message}"
    end
  end
end
