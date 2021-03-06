# cwt-ruby

Ruby implementation of RFC [8392](https://tools.ietf.org/html/rfc8392) CBOR Web Token (CWT)

[![Gem](https://img.shields.io/gem/v/cwt.svg?style=flat-square&color=informational)](https://rubygems.org/gems/cwt)
[![Actions Build](https://github.com/cedarcode/cwt-ruby/workflows/build/badge.svg)](https://github.com/cedarcode/cwt-ruby/actions)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cwt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cwt

## Usage

```ruby
cwt = CWT.decode(data, cose_key)

# Read claims
cwt.iss
cwt.sub
cwt.aud
cwt.exp
cwt.nbf
cwt.iat
cwt.cti
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cedarcode/cwt-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
