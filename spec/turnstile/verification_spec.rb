# frozen_string_literal: true

describe Turnstile::Verification do
  let(:remote_ip) { "123.456.789.1" }
  let(:response) { "some-response" }
  let(:server_url) { Turnstile.configuration.server_url }
  subject(:verification) { described_class.new(response: response, remote_ip: remote_ip) }

  describe "#success?" do
    let(:returned_result) { { success: true } }
    let!(:veritifcation_result) do
      stub_request(:post, server_url)
        .with(
          body: {
            response: response,
            secret: Turnstile.configuration.secret_key,
            remoteip: remote_ip
          },
        ).to_return(body: returned_result.to_json, headers: { "Content-Type" => "application/json" })
    end

    context "when verification is successful" do
      let(:returned_result) { { success: true } }

      it "returns true" do
        expect(verification.success?).to eq true
      end
    end

    context "when verification is not successful" do
      let(:returned_result) { { success: false } }

      it "returns false" do
        expect(verification.success?).to eq false
      end
    end
  end
end
