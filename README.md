# Turnstile

A gem to add [Cloudflare Turnstile](https://blog.cloudflare.com/turnstile-private-captcha-alternative/) to your Rails app.

```ruby
gem 'turnstile-captcha'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install turnstile-captcha

## Usage

Create an initializer and configure Turnstile with your Site Key and Secret Key:

    # config/initializers/turnstile.rb

    Turnstile.configure do |config|
        config.site_key = ...
        config.secret_key = ...
    end

In your controller, include the `Turnstile::ControllerMethods` module. This could be in a concern
or in your `ApplicationController`

    class ApplicationController < ..
        include Turnstile::ControllerMethods
    end

The gem also provides a helper module to generate the required tags by Turnstile:

    class ApplicationController < ..
        helper Turnstile::ViewHelpers
    end

To output the required tags, use `captcha_javascript_tag`, eg in your `<head>` tag:

    # application.html.erb

    <head>
        <%= captcha_javascript_tag %>
    </head>

And in your form, output the placeholder tag. You can provide an [`action`](https://developers.cloudflare.com/turnstile/get-started/client-side-rendering/#configurations):

    <%= captcha_placeholder_tag action: "login" %>

Upon submission, you can now validate the request using `valid_captcha?`:

    class SessionsController < ..
        def create
            if valid_captcha?
                ..
            end
        end
    end

Inspired by the [recaptcha gem](https://github.com/ambethia/recaptcha) you can provide a `model:` option.
In case of captcha failure, an error message will be added to the provided model on the `:base`:

    class UsersController < ..
        def create
            @user = User.new

            if valid_captcha?(model: @user)
                ..
            end
        end
    end

You can add an `on_failure` handler to for instance instrument failures. The proc will be called with the verification
result from Cloudflare:

    Turnstile.configure do |config|
        config.on_failure = ->(verification) { ErrorNotifier.notify("Captcha failure: #{verification.result}") }
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pfeiffer/turnstile-captcha. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pfeiffer/turnstile-captcha/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Turnstile project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pfeiffer/turnstile-captcha/blob/master/CODE_OF_CONDUCT.md).
