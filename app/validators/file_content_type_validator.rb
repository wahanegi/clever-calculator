class FileContentTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if options[:allowed_types].include?(value.content_type)

    record.errors.add(attribute, :invalid_content_type, message: options[:message])
  end
end
