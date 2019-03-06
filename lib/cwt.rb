# frozen_string_literal: true

require "cose/sign1"
require "cwt/claims"
require "cwt/version"

module CWT
  def self.create(claims, key)
    message = Claims.compact(claims)
    COSE::Signer.new(key).sign(message)
  end

  def self.validate(token, key)
    if token
      cose_sign1 = COSE::Sign1.new(token)

      if cose_sign1.valid?(key)
        cose_sign1.payload
      end
    end
  end
end
