# frozen_string_literal: true

class Turnstile::Railtie < Rails::Railtie
  ActiveSupport.on_load(:action_view) do
    include Turnstile::ViewHelpers
  end

  ActiveSupport.on_load(:action_controller) do
    include Turnstile::ControllerMethods
  end
end