# frozen_string_literal: true

# Base class for services
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
