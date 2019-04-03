# frozen_string_literal: true

require "cbor"

module CWT
  class Claims
    REGISTERED_CLAIMS = [
      { name: :iss, key: 1 },
      { name: :sub, key: 2 },
      { name: :aud, key: 3 },
      { name: :exp, key: 4, type: :timestamp },
      { name: :nbf, key: 5, type: :timestamp },
      { name: :iat, key: 6, type: :timestamp },
      { name: :cti, key: 7, type: :byte }
    ].freeze

    attr_reader :claims

    def initialize(claims = {})
      @claims = claims
    end

    def serialize
      CBOR.encode(map)
    end

    private

    def map
      map = claims.dup

      REGISTERED_CLAIMS.each do |claim|
        value = map.delete(claim[:name])

        if value
          map[claim[:key]] =
            if claim[:type] == :timestamp
              value.to_i
            else
              value
            end
        end
      end

      map
    end
  end
end
