require "net/http"

class ApiClient
  def initialize(url, headers = {}, body = {})
    @url = URI(url)
    @headers = headers
    @body = body.to_json
  end

  def get; request(:get); end
  def post; request(:post); end
  def put; request(:put); end
  def delete; request(:delete); end

  private

  def request(method)
    retries ||= 0

    request = build_request(method)
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = @url.scheme == "https"
    response = http.request(request)
    handle_response(response)
  rescue Errno::ETIMEDOUT
    log.error "Request timed out"
    retries += 1
    retry if (retries <= 5)
    # raise ApiError, "Request timed out"
    OpenStruct.new({
      success?: false,
      error: "Request timed out"
      })
  end

  def build_request(method)
    case method
    when :get
      request = Net::HTTP::Get.new(@url, @headers)
    when :post
      request = Net::HTTP::Post.new(@url, @headers)
      request.body = @body
    when :put
      request = Net::HTTP::Put.new(@url, @headers)
      request.body = @body
    when :delete
      request = Net::HTTP::Get.delete(@url, @headers)
    end

    return request
  end

  def handle_response(response)
    # return JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    if response.is_a?(Net::HTTPSuccess)
      return OpenStruct.new({
        success?: true,
        payload: JSON.parse(response.body)
      })
    end

    error_message = "Request failed with code #{response.code}: #{response.message}"
    # raise ApiError, error_message
    OpenStruct.new({
      success?: false,
      error: response,
      error_message: error_message,
      details: response.body
    })
  rescue JSON::ParserError
    # raise ApiError, "Unable to parse JSON response"
    OpenStruct.new({
      success?: false,
      error: "Unable to parse JSON response"
    })
  end
end

class ApiError < StandardError; end