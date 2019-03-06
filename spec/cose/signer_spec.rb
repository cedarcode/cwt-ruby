# frozen_string_literal: true

require "cbor"
require "cose/signer"

RSpec.describe "COSE::Signer" do
  describe "#sign with ECDSA256 by default" do
    before do
      @key = create_key
      signer = COSE::Signer.new(@key)
      @signed = signer.sign("payload")
    end

    it "includes CBOR tag by default" do
      expect(CBOR.decode(@signed)).to be_a(CBOR::Tagged)
      expect(CBOR.decode(@signed).tag).to eq(18)
    end

    it "is a CBOR array" do
      expect(CBOR.decode(@signed).value).to be_a(Array)
    end

    it "includes protected header bucket as a CBOR bstr" do
      decoded = CBOR.decode(@signed).value

      expect(CBOR.decode(decoded[0])).to be_a(Hash)
    end

    it "includes unprotected header bucket as a CBOR map" do
      decoded = CBOR.decode(@signed).value

      expect(decoded[1]).to be_a(Hash)
    end

    it "includes alg header in protected headers - defaults to ECDSA 256 (-7)" do
      decoded = CBOR.decode(@signed).value
      decoded_protected_headers = CBOR.decode(decoded[0])

      expect(decoded_protected_headers[1]).to eq(-7)
    end

    it "includes kid header in unprotected headers" do
      skip
    end

    it "includes the serialized payload" do
      decoded = CBOR.decode(@signed).value

      expect(CBOR.decode(decoded[2])).to eq("payload")
    end

    it "includes the signature bytes" do
      decoded = CBOR.decode(@signed).value

      expect(decoded[3].encoding).to eq(Encoding::ASCII_8BIT)
    end

    it "includes the correct signature" do
      decoded = CBOR.decode(@signed).value
      signature = decoded[3]
      verification_data = CBOR.encode(["Signature1", decoded[0], "".b, decoded[2]])

      expect(@key.verify("SHA256", signature, verification_data)).to be_truthy
    end
  end
end
