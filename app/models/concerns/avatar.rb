class Avatar
  include ActionView::Context
  include ActionView::Helpers::AssetTagHelper

  def self.call(user)
    new(user).call
  end

  attr_accessor :user
  
  def initialize(params)
    @user = params[:user]
    @classes = ['avatar-circle', params[:extra_classes]].flatten.compact.join(' ')
  end

  def call
    if gravatar_exists?
      gravatar_image
    else
      initials_element
    end  
  end

  private

  def gravatar_exists?
    hash = Digest::MD5.hexdigest(email)
    http = Net::HTTP.new('www.gravatar.com', 80)
    http.read_timeout = 2
    response = http.request_head("/avatar/#{hash}?default=http://gravatar.com/avatar")
    response.code != "302" ? true : false
  rescue StandardError, Timeout::Error
    false
  end

  def gravatar_image
    gravatar_id = Digest::MD5.hexdigest(email)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: email, class: @classes)
  end

  def initials_element
    initials = [email[0], email[1]].join('')
    style = "background-color: #{avatar_color(initials.first)};"
    content_tag :div, class: @classes, style: style do
      content_tag :div, initials, class: 'avatar-text'
    end
  end

  def email
    user.email
  end

  def initials
    email[0, 2]
  end
  
  def avatar_color(initial)
    colors = [
      '#00AA55', '#009FD4', '#B381B3', '#939393', '#E3BC00',
      '#D47500', '#DC2A2A', '#696969', '#ff0000', '#ff80ed',
      '#407294', '#133337', '#065535', '#c0c0c0', '#5ac18e',
      '#666666', '#f7347a', '#576675', '#696966', '#008080',
      '#ffa500', '#40e0d0', '#0000ff', '#003366', '#fa8072',
      '#800000'
    ]
      
    colors[initial.first.to_s.downcase.ord - 97] || '#000000'
  end

end