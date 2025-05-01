class ErrorSerializer
  def initialize(errors)
    @errors = errors
  end

  def serializable_hash
    {
      errors: @errors.attribute_names.index_with do |attribute|
        @errors.full_messages_for(attribute)
      end
    }
  end
end
