class OpenaiCompletion < ApplicationService
  
  def initialize(params)
    @prompt_text        = params[:prompt_text]
    @url                = "https://api.openai.com/v1/chat/completions"
  end

  def call
    result = ApiClient.new(@url, headers, body).post

    if result.success?
      handle_success(result.payload)
    else
      handle_error(result)
    end
  end

  private

  def headers
    {
      "Content-Type": "application/json",
      "Authorization": ["Bearer", Rails.application.credentials.dig(:open_ai, :api_key)].join(" ")
    }
  end

  def body
    {
      model: gpt_model,
      messages: [
        { "role": "system", "content": "You are Bob Ross and your are the art teacher of the user. Your are passionate about painting and art and you want to encourage your students to be creative and always practising." },
        { "role": "user", "content": @prompt_text }
      ],
      max_tokens: max_tokens,
      temperature: temperature
    }
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
    puts "🔥 OpenAI Input: #{@prompt_text} | Response: #{get_result_hash(result)[:choices].first[1]}"

    OpenStruct.new({
      success?: true, 
      payload: result, 
      result_hash: get_result_hash(result)
      })
  end

  def gpt_model
    # "gpt-3.5-turbo"
    "gpt-4"
  end

  def max_tokens
    nil
  end

  def temperature
    0.9
  end


  def get_result_hash(result)
    {
      id: result["id"],
      object: result["object"],
      created: result["created"],
      model: result["model"],
      choices: get_choices(result),
      usage: get_usage(result)
    }
  end

  def get_choices(result)
    choices = {}
    result["choices"].first.each { |k, v| choices[k.to_sym] = v }
  end

  def get_usage(result)
    usage = {}
    result["usage"].each { |k, v| usage[k.to_sym] = v }
  end
end