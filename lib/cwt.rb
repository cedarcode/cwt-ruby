require "cose/sign1"
require "cwt/version"

module CWT
  def self.validate(token)
    if token
      cose_sign1 = COSE::Sign1.new(token)

      if cose_sign1.valid?
        cose_sign1.payload
      end
    end
  end
end
