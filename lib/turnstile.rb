# frozen_string_literal: true

require "turnstile/configuration"
require "turnstile/controller_methods"
require "turnstile/view_helpers"
require "turnstile/verification"

require "turnstile/railtie" if defined?(Rails)

module Turnstile
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
