# frozen_string_literal: true

require "cbor"
require "cose/key"
require "cose/mac0"
require "cose/sign1"
require "cwt/claims_set"
require "cwt/version"

module CWT
  class Error < StandardError; end

  CBOR_TAG = 61

  def self.decode(token, cose_key)
    decoded = CBOR.decode(token)

    case decoded.tag
    when CBOR_TAG
      decode(CBOR.encode(decoded.value), cose_key)
    when COSE::Sign1.tag
      key = COSE::Key.deserialize(cose_key)
      sign1 = COSE::Sign1.deserialize(token)

      if sign1.verify(key)
        CWT::ClaimsSet.from_cbor(sign1.payload)
      else
        raise(CWT::Error, "Verification failed")
      end
    when COSE::Mac0.tag
      key = COSE::Key.deserialize(cose_key)
      mac0 = COSE::Mac0.deserialize(token)

      if mac0.verify(key)
        CWT::ClaimsSet.from_cbor(mac0.payload)
      else
        raise(CWT::Error, "Verification failed")
      end
    else
      raise(CWT::Error, "Unsupported tag #{decoded.tag}")
    end
  end
end
