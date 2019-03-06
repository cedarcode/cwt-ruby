# frozen_string_literal: true

module CWT
  class Claims
    REGISTERED_CLAIMS = [
      { name: "iss", key: 1 },
      { name: "sub", key: 2 },
      { name: "aud", key: 3 },
      { name: "exp", key: 4, type: :timestamp },
      { name: "nbf", key: 5, type: :timestamp },
      { name: "iat", key: 6, type: :timestamp },
      { name: "cti", key: 7, type: :byte }
    ].freeze

    def self.compact(claims)
      compated_claims = claims.dup

      REGISTERED_CLAIMS.each do |claim|
        value = compated_claims.delete(claim[:name])

        if value
          compated_claims[claim[:key]] =
            if claim[:type] == :timestamp
              value.to_i
            else
              value
            end
        end
      end

      compated_claims
    end
  end
end
