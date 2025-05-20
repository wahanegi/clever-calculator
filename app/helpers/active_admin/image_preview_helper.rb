module ActiveAdmin
  module ImagePreviewHelper
    def attached_image_or_fallback(attached_image, style: 'max-height: 100px; max-width: 300px;', fallback: 'No file uploaded')
      if attached_image.attached?
        image_tag attached_image, style: style
      else
        fallback
      end
    end
  end
end
