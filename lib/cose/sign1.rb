# frozen_string_literal: true

require "cbor"

module COSE
  class Sign1
    CONTEXT = "Signature1"

    def initialize(data)
      @data = data
    end

    def valid?(key)
      cbor && valid_signature?(key)
    end

    def payload
      cbor[2]
    end

    private

    attr_reader :data

    def valid_signature?(key)
      key.verify(
        "SHA256",
        signature,
        to_be_signed
      )
    rescue OpenSSL::PKey::PKeyError
      false
    end

    def to_be_signed
      sig_structure = [
        CONTEXT,
        protected_headers,
        "",
        payload
      ]

      CBOR.encode(sig_structure)
    end

    def protected_headers
      cbor[0]
    end

    def signature
      cbor[3]
    end

    def cbor
      @cbor ||=
        begin
          CBOR.decode(data)
        rescue
          nil
        end
    end
  end
end
