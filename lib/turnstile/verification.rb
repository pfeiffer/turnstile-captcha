# frozen_string_literal: true

require "faraday"
require "hashie/mash"

class Turnstile::Verification
  attr_reader :response, :remote_ip

  def initialize(response:, remote_ip:)
    @response = response
    @remote_ip = remote_ip
  end

  def result
    @result ||= begin
      response = perform_verification

      Hashie::Mash.new(response.body)
    end
  end

  def success?
    result.success?
  end

  private

  def perform_verification
    client.post \
      Turnstile.configuration.server_url,
      response: response,
      secret: Turnstile.configuration.secret_key,
      remoteip: remote_ip
  end

  def client
    @client ||= Faraday.new do |conn|
      conn.request :url_encoded
      conn.response :json
      conn.adapter Faraday.default_adapter
    end
  end
end
