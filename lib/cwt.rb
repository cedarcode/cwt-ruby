# frozen_string_literal: true

require "cose/key"
require "cose/sign1"
require "cwt/claims_set"
require "cwt/version"

module CWT
  class Error < StandardError; end

  def self.decode(token, public_key)
    key = COSE::Key.deserialize(public_key)
    sign1 = COSE::Sign1.deserialize(token)

    if sign1.verify(key)
      CWT::ClaimsSet.from_cbor(sign1.payload)
    else
      raise(CWT::Error, "Verification failed")
    end
  end
end
