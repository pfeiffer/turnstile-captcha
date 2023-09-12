# frozen_string_literal: true

require "action_view"

describe Turnstile::ViewHelpers do
  include Turnstile::ViewHelpers
  include ActionView::Helpers

  before do
    Turnstile.configure do |config|
      config.site_key = "some-site-key"
      config.script_url = "some-script-url"
    end
  end

  describe "#captcha_javascript_tag" do
    subject { captcha_javascript_tag }

    it { is_expected.to match javascript_include_tag(Turnstile.configuration.script_url, async: true, defer: true) }
  end

  describe "#captcha_placeholder_tag" do
    subject { captcha_placeholder_tag(action: "login") }

    it { is_expected.to match(/<div class="cf-turnstile" data-action="login" data-sitekey="#{Turnstile.configuration.site_key}">/) }
  end

  describe "#captcha_tags" do
    it "returns the javascript and placeholder tags" do
      expect(captcha_tags(action: "login")).to include captcha_javascript_tag
      expect(captcha_tags(action: "login")).to include captcha_placeholder_tag(action: "login")
    end

    it "allows overriding the javascript tag options" do
      expect(captcha_tags(action: "login", javascript_tag: { async: false }))
        .to include javascript_include_tag(Turnstile.configuration.script_url, async: false, defer: true)
    end
  end
end
