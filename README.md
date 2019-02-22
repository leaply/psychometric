# Psychometric

This gem attempts to create a simple uniform structure for results of
psychometric assessments from various providers. It also implements methods to
request those results from the providers' APIs.

Persisting the results is left to the consumer.

It has been extracted from the [Leaply](https://leap.ly) recruitment platform.

### Currently Supported Providers

* [Top Talent Solutions](https://www.tts-talent.com/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'psychometric'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install psychometric

## Usage

* Require the gem and the provider(s) you need.
* Provide your authentication and assessment requirements.
* Request the results.

```ruby
# All providers are not required by default
require "psychometric"
require "psychometric/providers/top_talent_solutions"

# Create an instance of the Provider
provider = Psychometric::Providers::TopTalentSolutions.new username: 'psycho@metric.com', password: 'insecure'
# Authenticate the instance (most will need this step)
provider.authenticate!
# Indicate which Assessment (params needed specific to provider)
assessment = Psychometric::Providers::TopTalentSolutions.assessment project_id: 1234, model_id: 5678
# Fetch the results
results = provider.results assessment

results #=> [#<Psychometric::Result subject: "#<Psychometric::Subject name: "John Doe" identity: "8801235111088">" values: {"Numbers"=>"5", "Letters"=>"7", "Shapes"=>"3"}>]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Leaply/psychometric. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Psychometric project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Leaply/psychometric/blob/master/CODE_OF_CONDUCT.md).
