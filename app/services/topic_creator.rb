class TopicCreator < ApplicationService
  def initialize(params)
    @previous_topics = params[:previous_topics]
  end

  def call
    result = OpenaiCompletion.call(prompt_text: prompt_text)
   
    if result.success?
      handle_success(result)
    else
      handle_error(result)
    end
  end

  private

  def prompt_text
    "#{topic}\n\n#{format_instructions}\n\nPrevious topics were:\n\n#{previous_topics}.\n\nPlease provide a new topic."
  end

  def previous_topics
    return "No previous topics" if @previous_topics.nil?

    @previous_topics.join("\n")
  end

  def topic
    "You are an art teacher and you have a group of students coming together every week to each draw one painting. You are responsible for providing the students with a subject they have to base their weekly painting on. It should be a new topic every week. The topic doesn't always have to be in the Bob Ross fashion about nature, but could also be about something unexpected, unusual or even controversial."
  end

  def format_instructions
    "Your answer should be formatted as follows:\n\nTitle: <title of your topic>\n\nDescription: <description of your topic>\n\nYou should speak in the first person, as if you were the art teacher."
  end

  def handle_error(error)
    puts "🔥 OpenAI: #{error.error_message}"
    
    OpenStruct.new({
      success?: false, 
      error: error,
      error_message: error.error_message
    })
  end

  def handle_success(result)
    puts "🔥 OpenAI Input: #{prompt_text} | Response: #{result.result_hash}"

    OpenStruct.new({
      success?: true, 
      payload: result.result_hash
      })
    
  end
end