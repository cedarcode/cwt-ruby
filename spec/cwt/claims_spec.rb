# frozen_string_literal: true

require "cwt/claims"

RSpec.describe "Claims" do
  describe ".compact" do
    it "codifies registered claims" do
      now = Time.now

      claims = {
        "iss" => "issuer",
        "sub" => "subject",
        "aud" => "audience",
        "exp" => now + 100,
        "nbf" => now,
        "iat" => now,
        "cti" => "1".b
      }

      compated = CWT::Claims.compact(claims)

      expect(compated[1]).to eq("issuer")
      expect(compated[2]).to eq("subject")
      expect(compated[3]).to eq("audience")
      expect(compated[4]).to eq(now.to_i + 100)
      expect(compated[5]).to eq(now.to_i)
      expect(compated[6]).to eq(now.to_i)
      expect(compated[7]).to eq("1".b)
    end

    it "leaves untouched unknown claims" do
      compated = CWT::Claims.compact("iss" => "issuer", 10 => "ten")

      expect(compated[1]).to eq("issuer")
      expect(compated[10]).to eq("ten")
    end

    it "removes original named claims" do
      compated = CWT::Claims.compact("iss" => "issuer")

      expect(compated[1]).to eq("issuer")
      expect(compated.has_key?("iss")).to be_falsy
    end
  end
end
