# frozen_string_literal: true

module Turnstile::ControllerMethods
  def valid_captcha?(*args)
    return true unless Turnstile.configuration.enabled

    options = args.extract_options!
    verification = Turnstile::Verification.new(response: params["cf-turnstile-response"], remote_ip: request.remote_ip)

    return true if verification.success?

    Turnstile.configuration.on_failure&.call(verification)

    if options[:model].respond_to?(:errors)
      options[:model].errors.add(:base, :invalid_captcha, message: "Captcha verification failed")
    end

    false
  end
end
