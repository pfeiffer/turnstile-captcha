# Turnstile

A gem to add [Cloudflare Turnstile](https://blog.cloudflare.com/turnstile-private-captcha-alternative/) to your Rails app.

```ruby
gem 'turnstile-captcha', require: 'turnstile'
```

And then execute:

    $ bundle install

## Usage

Create an initializer and configure Turnstile with your Site Key and Secret Key:

```ruby
# config/initializers/turnstile.rb

Turnstile.configure do |config|
  config.site_key = ...
  config.secret_key = ...
end
```

You now have access to the Turnstile view and controller helpers.

To output the required tags, use `captcha_javascript_tag`, eg in your `<head>` tag:

```erb
# application.html.erb

<html>
  <head>
    ...
    <%= captcha_javascript_tag %>
    ...
  </head>
  ...
</html>
```

And in your form, output the placeholder tag. You can provide an [`action`](https://developers.cloudflare.com/turnstile/get-started/client-side-rendering/#configurations):

```erb
<%= form_for @user do |f| %>
  ..
  <%= captcha_placeholder_tag action: "login" %>
  ..
<% end %>
```

You can also output both of these tags together, eg. if you only have a single form on the page:

```erb
<%= form_for @user do |f| %>
  ...
  <%= captcha_tags action: "login" %>
  ...
<% end %>
```

Upon submission, you can now validate the request using `valid_captcha?`:

```ruby
class SessionsController < ..
  def create
    if valid_captcha?
      # Perform
    end
  end
end
```

Inspired by the [recaptcha gem](https://github.com/ambethia/recaptcha) you can provide a `model:` option.
In case of captcha failure, an `:invalid_captcha` error will be added to the provided model on the `:base`,
which can be localized using Rails I18n.

```ruby
class UsersController < ..
  def create
    @user = User.new(..)

    if valid_captcha?(model: @user)
      # Perform
    else
      # @user.errors.details
      # => {:base=>[{error: :invalid_captcha}]}
    end
  end
end
```

## Configuration

You can add an `on_failure` handler to for instance instrument failures.
The proc will be called with the verification result from Cloudflare:

```ruby
Turnstile.configure do |config|
  config.on_failure = ->(verification) { ErrorNotifier.notify("Captcha failure: #{verification.result}") }
end
```

It is also possible to globally disable/enable Turnstile captcha validation, eg. in CI:

```ruby
Turnstile.configure do |config|
  config.enabled = ENV["ENABLE_TURNSTILE"]
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pfeiffer/turnstile-captcha. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pfeiffer/turnstile-captcha/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Turnstile project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pfeiffer/turnstile-captcha/blob/master/CODE_OF_CONDUCT.md).
