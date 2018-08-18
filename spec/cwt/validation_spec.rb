require "cbor"

RSpec.describe "Validation" do
  it "returns false if nil" do
    expect(CWT.validate(nil, create_key)).to be_falsy
  end

  it "returns false if random string" do
    expect(CWT.validate("whatever", create_key)).to be_falsy
  end

  it "returns false if signature is invalid" do
    key = create_key
    token = create_token(key: key, payload: { 1 => 1 }, signature: "invalid")

    payload = CWT.validate(token, key)

    expect(payload).to be_falsy
  end

  it "returns payload if valid" do
    key = create_key
    token = create_token(key: key, payload: { 1 => 1 })

    payload = CWT.validate(token, key)

    expect(payload).to be_truthy
    expect(payload).to eq(1 => 1)
  end
end
