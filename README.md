# Darksea UI

Darksea UI is a collection of reusable UI components for Rails applications, styled with Tailwind CSS.

## Installation

Add this line to your application's Gemfile:

ruby
gem 'darksea-ui', github: 'your-username/ui'


And then execute:

    $ bundle install

## Usage

Include the helpers in your `ApplicationController`:

ruby
class ApplicationController < ActionController::Base
helper UI::ComponentHelpers
end


Now you can use the components in your views:

erb
<%= Button(variant: :primary) do %>
Click me
<% end %>

Or with the full namespace:
erb
<%= render(UI::ButtonComponent.new(variant: :primary)) do %>
Click me
<% end %>


## Available Components

- Button
- Card

## Customization

You can customize the appearance of components by adjusting your Tailwind CSS configuration.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/your-username/ui.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).