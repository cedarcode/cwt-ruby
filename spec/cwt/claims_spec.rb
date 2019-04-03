# frozen_string_literal: true

require "cbor"
require "cwt/claims"

RSpec.describe "Claims" do
  describe ".deserialize" do
    pending
  end

  describe "#serialize" do
    it "serializes all registered claims" do
      now = Time.now

      claims = CWT::Claims.new(
        iss: "issuer",
        sub: "subject",
        aud: "audience",
        exp: now + 100,
        nbf: now,
        iat: now,
        cti: "1".b
      )

      cbor = claims.serialize
      map = CBOR.decode(cbor)

      expect(map.keys.size).to eq(7)
      expect(map[1]).to eq("issuer")
      expect(map[2]).to eq("subject")
      expect(map[3]).to eq("audience")
      expect(map[4]).to eq(now.to_i + 100)
      expect(map[5]).to eq(now.to_i)
      expect(map[6]).to eq(now.to_i)
      expect(map[7]).to eq("1".b)
    end

    it "leaves untouched unregistered integer claims" do
      claims = CWT::Claims.new(iss: "issuer", 10 => "ten")

      cbor = claims.serialize
      map = CBOR.decode(cbor)

      expect(map.keys.size).to eq(2)
      expect(map[1]).to eq("issuer")
      expect(map[10]).to eq("ten")
    end

    it "leaves untouched unregistered string claims" do
      claims = CWT::Claims.new(iss: "issuer", ten: "ten")

      cbor = claims.serialize
      map = CBOR.decode(cbor)

      expect(map.keys.size).to eq(2)
      expect(map[1]).to eq("issuer")
      expect(map["ten"]).to eq("ten")
    end
  end
end
