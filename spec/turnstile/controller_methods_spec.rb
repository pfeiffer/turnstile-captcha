# frozen_string_literal: true

require "action_controller"

describe Turnstile::ControllerMethods, :controller do
  class SomeController < ActionController::Base
    include Turnstile::ControllerMethods
  end

  let(:controller) { SomeController.new }
  let(:remote_ip) { "123.456.789.1" }
  let(:request) { double("request", remote_ip: remote_ip) }
  let(:verification) { double("verification", success?: true) }

  describe "#valid_captcha?" do
    before do
      allow(controller).to receive(:request).and_return(request)
      allow(controller).to receive(:params).and_return("cf-turnstile-response" => "some-response")
      allow(Turnstile::Verification).to receive(:new).with(response: "some-response", remote_ip: remote_ip).and_return(verification)
    end

    it "returns true if the verification is success" do
      expect(controller.valid_captcha?).to eq true
    end

    it "returns true when not enabled" do
      allow(verification).to receive(:success?).and_return(false)
      allow(Turnstile.configuration).to receive(:enabled).and_return(false)

      expect(controller.valid_captcha?).to eq true
    end

    context "when the verification fails" do
      before do
        allow(verification).to receive(:success?).and_return(false)
      end

      it "returns false" do
        expect(controller.valid_captcha?).to eq false
      end

      it "calls the on_failure callback" do
        called = false
        Turnstile.configuration.on_failure = ->(_) { called = true }

        controller.valid_captcha?

        expect(called).to eq true
      end

      context "and :model is provided" do
        it "adds an error to the model" do
          errors = double("Errors")
          model = double("Model", errors: errors)

          expect(errors).to receive(:add).with(:base, :invalid_captcha, message: "Captcha verification failed")
          expect(controller.valid_captcha?(model: model)).to eq false
        end
      end
    end
  end
end
