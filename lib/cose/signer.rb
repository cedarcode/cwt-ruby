# frozen_string_literal: true

# TODO move this to cose gem
module COSE
  class Signer
    ALG_ECDSA_256 = -7
    CBOR_TAG = 18
    CONTEXT = "Signature1"
    HEADER_LABEL_ALG = 1
    ZERO_LENGTH_BIN_STRING = "".b

    def initialize(key)
      @key = key
    end

    def sign(payload)
      CBOR::Tagged.new(
        CBOR_TAG,
        [CBOR.encode(protected_headers), unprotected_headers, CBOR.encode(payload), signature(payload)]
      ).to_cbor
    end

    private

    attr_reader :key

    def protected_headers
      { HEADER_LABEL_ALG => ALG_ECDSA_256 }
    end

    def unprotected_headers
      {}
    end

    def signature(payload)
      key.sign("SHA256", to_be_signed(payload))
    end

    def to_be_signed(payload)
      CBOR.encode([CONTEXT, CBOR.encode(protected_headers), ZERO_LENGTH_BIN_STRING, CBOR.encode(payload)])
    end
  end
end
