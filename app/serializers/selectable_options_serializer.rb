class SelectableOptionsSerializer
  def initialize(options)
    @options = options
  end

  def serializable_hash
    @options.map { |option| generate_data(option) }
  end

  private

  def generate_data(model)
    {
      id: model.id,
      name: model.name,
      type: model.class.name.downcase
    }
  end
end
