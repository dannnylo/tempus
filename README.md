# Tempus

<a href='http://badge.fury.io/rb/tempus'>
    <img src="https://badge.fury.io/rb/tempus.png" alt="Gem Version" />
</a>

Gem to efficiently manipulate the time, adding, subtracting and converting hours.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tempus'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install tempus

## Usage
 With this gem you can manage durations of time.

### Initialize with duration
```ruby
  hours = Tempus.new(30.hours  + 5.minutes + 3.seconds)
  => <Tempus:8508680 seconds=108303.0, formated=30:05:03>
  hours.value_in_minutes
  => 1805.05
  hours.to_s("%H hours and %M minutes")
  => "30 hours and 05 minutes"
```
### Convert from other types
```ruby
  hours = "35:05:01".to_tempus
  => <Tempus:7228060 seconds=126301.0, formated=35:05:01>
  hours + 6.hours
  => <Tempus:6931320 seconds=147901.0, formated=41:05:01>
```
```ruby
  Tempus.new(Time.now)
  => <Tempus:6578680 seconds=46455.162950918, formated=12:54:15>
```

### Sum durations

```ruby
  "1:00:00".to_tempus + "2:00"
  => <Tempus:6634700 seconds=10800.0, formated=03:00:00>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dannnylo/tempus. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/dannnylo/tempus/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tempus project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dannnylo/tempus/blob/master/CODE_OF_CONDUCT.md).
