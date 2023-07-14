module ApplicationHelper
  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash", partial: "shared/flash"
  end

  def form_error_notification(object)
    if object.errors.any?
      tag.div class: "error-message" do
        object.errors.full_messages.to_sentence.capitalize
      end
    end
  end

  def nested_dom_id(*args)
    args.map { |arg| arg.respond_to?(:to_key) ? dom_id(arg) : arg }.join("_")
  end

  def formatted_date(date)
    date.strftime("%A, %e %b %Y")
  end

  def company_link
    link_to company_name, root_path
  end

  def company_name
    "Hue Hub"
  end

  def convert_to_days_and_hours(seconds)
    days = (seconds / 86400).floor
    hours = ((seconds / 3600) % 24).floor
    minutes = ((seconds / 60) % 60).floor

    if days > 0
      "#{days} days and #{hours} hours"
    elsif hours > 0
      "#{hours} hours and #{minutes} minutes"
    else
      "#{minutes} minutes"
    end
  end
    


  def dropzone_controller_div(max_files = 4)
    data = {
      controller: "dropzone",
      'dropzone-max-file-size'=>"10",
      'dropzone-max-files' => "#{max_files}",
      'dropzone-accepted-files' => 'image/jpeg,image/jpg,image/png,image/gif',
      'dropzone-dict-file-too-big' => "Your file ({{filesize}} MB) is larger than allowed ({{maxFilesize}} MB)",
      'dropzone-dict-invalid-file-type' => "Invalid file type. Only jpg, .png or .gif are allowed",
    }
    
    content_tag :div, class: 'dropzone dropzone-default dz-clickable', data: data do
      yield
    end
  end
end
