require "cbor"

module COSE
  class Sign1
    def initialize(data)
      @data = data
    end

    def valid?
      cbor
    end

    def payload
      cbor[2]
    end

    private

    attr_reader :data

    def cbor
      @cbor ||=
        begin
          CBOR.decode(data)
        rescue
        end
    end
  end
end
