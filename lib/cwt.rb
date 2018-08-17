require "cwt/version"

module CWT
  def self.validate(token)
    begin
      CBOR.decode(token)
    rescue
    end
  end
end
