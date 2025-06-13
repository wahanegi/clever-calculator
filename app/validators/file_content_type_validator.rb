class FileContentTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if options[:allowed_types].include?(value.content_type)

    record.errors.add(attribute, :invalid_content_type,
                      message: options[:message] || content_type_message)
  end

  private

  def content_type_message
    message = options[:allowed_types].map do |type|
      type.split('/').last.upcase
    end.to_sentence(last_word_connector: ', or ', two_words_connector: ' or ')

    "must be a #{message} file"
  end
end
