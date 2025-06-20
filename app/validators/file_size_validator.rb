class FileSizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.byte_size > options[:max]

    record.errors.add(attribute, :invalid_size,
                      message: options[:message] || invalid_size_message)
  end

  private

  def invalid_size_message
    "must be less than #{options[:max] / 1.megabyte}MB"
  end
end
