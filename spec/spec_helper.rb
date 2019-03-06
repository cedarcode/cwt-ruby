# frozen_string_literal: true

require "bundler/setup"
require "byebug"
require "cwt"
require "openssl"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def create_token(payload: {}, key:, signature: nil)
  protected_headers = ""
  unprotected_headers = ""

  signature ||= create_signature(
    protected_headers: protected_headers,
    payload: payload,
    key: key
  )

  CBOR.encode([protected_headers, unprotected_headers, payload, signature])
end

def create_key
  OpenSSL::PKey::EC.new("prime256v1").generate_key
end

def create_signature(protected_headers:, payload:, key:)
  sig_structure = [
    "Signature1",
    protected_headers,
    "",
    payload
  ]

  to_be_signed = CBOR.encode(sig_structure)

  key.sign("SHA256", to_be_signed)
end
