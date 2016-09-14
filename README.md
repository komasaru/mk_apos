# MkApos

This is the gem library which calculates apparent positions of SUn and Moon.

## Preparation

This library needs a JPL's DE430 binary file.

Download linux_p1550p2650.430 from [ftp://ssd.jpl.nasa.gov/pub/eph/planets/Linux/de430/](ftp://ssd.jpl.nasa.gov/pub/eph/planets/Linux/de430/), and place at a suitable directory.

If neccessary, rename the binary file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mk_apos'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mk_apos

## Usage

### Instantiation

    require "mk_apos"
    
    a = MkApos.new("/path/to/<JPLEPH binary>", "20160914")
    a = MkApos.new("/path/to/<JPLEPH binary>", "20160914123456")
    a = MkApos.new("/path/to/<JPLEPH binary>", "2016091412345698765")
    a = MkApos.new("/path/to/<JPLEPH binary>")

* You can set UTC formatted `YYYYMMDD` or `YYYYMMDDHHMMSS` or `YYYYMMDDHHMMSSU...` as an argument. (`U` is microsecond)
* If you don't set a second argument, this class considers the system time to have been set as a second argument.

### Calculation

    p a.utc.strftime('%Y-%m-%d %H:%M:%S.%3N')
    p a.tdb.strftime('%Y-%m-%d %H:%M:%S.%3N')
    p a.jd_tdb
    p a.sun
    p a.moon

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/komasaru/mk_apos.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

