# frozen_string_literal: true

module Turnstile::ViewHelpers
  def captcha_tags(options = {})
    [
      captcha_javascript_tag,
      captcha_placeholder_tag(options)
    ].join.html_safe
  end

  def captcha_javascript_tag
    javascript_include_tag Turnstile.configuration.script_url, async: true, defer: true
  end

  def captcha_placeholder_tag(options = {})
    action = options.delete(:action)
    attrs = {
      class: "cf-turnstile",
      data: {
        action: action,
        sitekey: Turnstile.configuration.site_key
      }
    }.deep_merge(options)

    content_tag :div, "", attrs
  end
end
