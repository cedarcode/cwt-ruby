# frozen_string_literal: true

require "cbor"

module CWT
  class ClaimsSet
    LABEL_ISS = 1
    LABEL_SUB = 2
    LABEL_AUD = 3
    LABEL_EXP = 4
    LABEL_NBF = 5
    LABEL_IAT = 6
    LABEL_CTI = 7

    def self.from_cbor(cbor)
      from_map(CBOR.decode(cbor))
    end

    def self.from_map(map)
      new(
        iss: map[LABEL_ISS],
        sub: map[LABEL_SUB],
        aud: map[LABEL_AUD],
        exp: map[LABEL_EXP],
        nbf: map[LABEL_NBF],
        iat: map[LABEL_IAT],
        cti: map[LABEL_CTI]
      )
    end

    attr_reader :iss, :sub, :aud, :exp, :nbf, :iat, :cti

    def initialize(iss:, sub:, aud:, exp:, nbf:, iat:, cti:)
      @iss = iss
      @sub = sub
      @aud = aud
      @exp = exp
      @nbf = nbf
      @iat = iat
      @cti = cti
    end

    def expired?
      Time.now >= expiration_time
    end

    def expiration_time
      Time.at(exp)
    end
  end
end
