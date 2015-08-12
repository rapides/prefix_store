# PrefixStore

PrefixStore is an ActiveRecord extension to give an addictional method prefix_store_accessor which creates store_accessor getters and setters with prefix named by column.

# Usage

Default:

```ruby
# == Schema Information
#
# Table name: Car
#
#  id                                   :integer          not null, primary key
#  user_id                              :integer
#  name                                 :string(255)
#  spec                                 :json             default({}), not null
#

class Car < ActiveRecord::Base

    store_accessor  :spec,
                    :engine,
                    :v_max_km,
                    :country
    
    ...
end
```
    $ [1] pry(main)> Car.last.v_max_km
    $ Car Load (1.5ms)  SELECT "cars".* FROM "cars" ORDER BY "cars"."id" DESC LIMIT 1
    $ => "225"


Solution with a prefix accessor:

```ruby
# == Schema Information
#
# Table name: Car
#
#  id                                   :integer          not null, primary key
#  user_id                              :integer
#  name                                 :string(255)
#  spec                                 :json             default({}), not null
#

class Car < ActiveRecord::Base

    prefix_store_accessor   :spec,
                            :engine,
                            :v_max_km,
                            :country
    
    ...
end
```
    $ [1] pry(main)> Car.last.spec_v_max_km
    $ Car Load (1.5ms)  SELECT "cars".* FROM "cars" ORDER BY "cars"."id" DESC LIMIT 1
    $ => "225"


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prefix_store'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prefix_store

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/prefix_store.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

