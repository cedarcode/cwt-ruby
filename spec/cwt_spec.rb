# frozen_string_literal: true

require "timecop"

RSpec.describe CWT do
  # https://tools.ietf.org/html/rfc8392#appendix-A.3
  it "decodes example A.3 (Signed CWT)" do
    signed_cwt = hex_to_bytes(
      "d28443a10126a104524173796d6d657472696345434453413235365850a70175636f61703a2f2f"\
      "61732e6578616d706c652e636f6d02656572696b77037818636f61703a2f2f6c696768742e6578"\
      "616d706c652e636f6d041a5612aeb0051a5610d9f0061a5610d9f007420b7158405427c1ff28d2"\
      "3fbad1f29c4c7c6a555e601d6fa29f9179bc3d7438bacaca5acd08c8d4d4f96131680c429a01f8"\
      "5951ecee743a52b9b63632c57209120e1c9e30"
    )

    public_key = hex_to_bytes(
      "a72358206c1382765aec5358f117733d281c1c7bdc39884d04a45a1e6c67c858bc206c19225820"\
      "60f7f1a780d8a783bfb7a2dd6b2796e8128dbbcef9d3d168db9529971a36e7b9215820143329cc"\
      "e7868e416927599cf65a34f3ce2ffda55a7eca69ed8919a394d42f0f2001010202524173796d6d"\
      "657472696345434453413235360326"
    )

    decoded_cwt = CWT.decode(signed_cwt, public_key)

    expect(decoded_cwt.iss).to eq("coap://as.example.com")
    expect(decoded_cwt.sub).to eq("erikw")
    expect(decoded_cwt.aud).to eq("coap://light.example.com")
    expect(decoded_cwt.exp).to eq(1444064944)
    expect(decoded_cwt.nbf).to eq(1443944944)
    expect(decoded_cwt.iat).to eq(1443944944)
    expect(decoded_cwt.cti).to eq(hex_to_bytes("0b71"))

    Timecop.freeze(Time.at(1444064944 + 1)) do
      expect(decoded_cwt.expired?).to be_truthy
    end

    Timecop.freeze(Time.at(1444064944)) do
      expect(decoded_cwt.expired?).to be_truthy
    end

    Timecop.freeze(Time.at(1444064944 - 1)) do
      expect(decoded_cwt.expired?).to be_falsy
    end
  end

  it "decodes example A.4 (MACed CWT)" do
    data = hex_to_bytes(
      "d83dd18443a10104a1044c53796d6d65747269633235365850a70175636f6170"\
      "3a2f2f61732e6578616d706c652e636f6d02656572696b77037818636f61703a"\
      "2f2f6c696768742e6578616d706c652e636f6d041a5612aeb0051a5610d9f006"\
      "1a5610d9f007420b7148093101ef6d789200"
    )

    cose_key = hex_to_bytes(
      "a4205820403697de87af64611c1d32a05dab0fe1fcb715a86ab435f1ec99192d"\
      "795693880104024c53796d6d6574726963323536030a"
    )

    cwt = CWT.decode(data, cose_key)

    expect(cwt.iss).to eq("coap://as.example.com")
    expect(cwt.sub).to eq("erikw")
    expect(cwt.aud).to eq("coap://light.example.com")
    expect(cwt.exp).to eq(1444064944)
    expect(cwt.nbf).to eq(1443944944)
    expect(cwt.iat).to eq(1443944944)
    expect(cwt.cti).to eq(hex_to_bytes("0b71"))
  end

  it "decodes example A.7 (MACed CWT with a Floating-Point Value)" do
    data = hex_to_bytes(
      "d18443a10104a1044c53796d6d65747269633235364ba106fb41d584367c2000"\
      "0048b8816f34c0542892"
    )

    cose_key = hex_to_bytes(
      "a4205820403697de87af64611c1d32a05dab0fe1fcb715a86ab435f1ec99192d"\
      "795693880104024c53796d6d6574726963323536030a"
    )

    cwt = CWT.decode(data, cose_key)

    expect(cwt.iss).to eq(nil)
    expect(cwt.sub).to eq(nil)
    expect(cwt.aud).to eq(nil)
    expect(cwt.exp).to eq(nil)
    expect(cwt.nbf).to eq(nil)
    expect(cwt.iat).to eq(1443944944.5)
    expect(cwt.cti).to eq(nil)
  end
end
