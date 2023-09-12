# frozen_string_literal: true

module Turnstile::ViewHelpers
  def captcha_tags(options = {})
    javascript_tag_options = options.delete(:javascript_tag) || {}

    [
      captcha_javascript_tag(javascript_tag_options),
      captcha_placeholder_tag(options)
    ].join.html_safe
  end

  def captcha_javascript_tag(options = {})
    javascript_include_tag Turnstile.configuration.script_url, **options.reverse_merge(async: true, defer: true)
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
