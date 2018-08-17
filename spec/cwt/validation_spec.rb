require "cbor"

RSpec.describe "Validation" do
  it "returns false if nil" do
    expect(CWT.validate(nil)).to be_falsy
  end

  it "returns false if random string" do
    expect(CWT.validate("whatever")).to be_falsy
  end

  it "returns true if valid CBOR map" do
    expect(CWT.validate(CBOR.encode(1 => 1))).to be_truthy
  end
end
