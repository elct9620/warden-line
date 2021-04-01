# Warden::Line
[![Build Status](https://travis-ci.com/elct9620/warden-line.svg?branch=main)](https://travis-ci.com/elct9620/warden-line) [![Maintainability](https://api.codeclimate.com/v1/badges/33f1eefd4a94ed7ece86/maintainability)](https://codeclimate.com/github/elct9620/warden-line/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/33f1eefd4a94ed7ece86/test_coverage)](https://codeclimate.com/github/elct9620/warden-line/test_coverage)

This gem is created for use LINE ID Token as warden strategies to use in LIFF application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'warden-line'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install warden-line

## Usage

Currently, the workable version is tested with Rails.

```ruby
# config/initialize/warden.rb

Rails.configuration.middleware.use Warden::Manager do |manager|
  manager.failure_app = proc do |env|
    Rails.logger.error(env['warden'].message)
    [
      401,
      { 'Content-Type' => 'application/json' },
      [{ error: 'Unauthorized', code: 401, reason: env['warden'].message }.to_json]
    ]
  end
  manager.default_strategies :line
  manager.line_client_id = ENV['LINE_CLIENT_ID']
end
```

Create a plain object as model for decoded user.

```ruby
# app/models/user.rb

class User
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :sub, :string
  attribute :exp, :integer
  attribute :name, :string
  attribute :picture, :string
  attribute :email, :string

  def id
    sub
  end

  def expired_at
    @expired_at ||= Time.zone.at(exp)
  rescue TypeError
    Time.zone.now
  end

  def expired?
    Time.zone.now >= expired_at
  end
end
```

Implement a controller to handle the session creation for sign-in and sign-out.

```ruby
# app/controller/sessions.rb

class SessionsController < ActionController::Metal
  include Authenticatable

  def authenticate
    # Ensure clear expired session
    request.env['warden'].logout
    request.env['warden'].authenticate!

    @user = User.new(request.env['warden'].user.slice(*User.attribute_names))
    # Post login actions
  end
end
```

> Note: The Rack does not parse JSON body, please use GET with query string or POST with HTML Form to authenticate.

## Roadmap

* [x] Strategy for LINE ID Token
* [ ] Rails Support
  * [x] Remove `rails_warden` dependency
  * [ ] Helpers similar to `devise`
* [ ] User object

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elct9620/warden-line. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/elct9620/warden-line/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the Warden::Line project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/elct9620/warden-line/blob/master/CODE_OF_CONDUCT.md).
