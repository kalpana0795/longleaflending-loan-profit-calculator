class Response
  attr_reader :data, :errors

  def initialize(data:, errors:)
    @data = data
    @errors = errors
  end

  def success?
    errors.blank?
  end
end
