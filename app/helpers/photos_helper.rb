module PhotosHelper
  def photo_or_fallback(photo)
    photo.attached? ? photo.key : image_path('fallback_painting.jpg')
  end
end