# frozen_string_literal: true

module UI
  # InputComponent is a ViewComponent that renders an HTML input element with customizable attributes.
  # It provides a flexible and reusable way to create input fields with consistent styling across the application.
  #
  # Features:
  # - Customizable input type (text, password, email, etc.)
  # - Additional CSS classes can be added
  # - Disabled state support
  # - Accepts and passes through additional HTML attributes
  # - Consistent base styling with focus and disabled states
  #
  # Usage:
  #   <%= input(type: 'email', placeholder: 'Enter your email') %>
  class InputComponent < ViewComponent::Base
    def initialize(type: 'text', class_name: '', disabled: false, **options)
      super
      @type = type
      @class_name = class_name
      @disabled = disabled
      @options = options
    end

    def call
      tag.input(
        type: @type,
        class: input_classes,
        disabled: @disabled,
        **@options
      )
    end

    private

    def input_classes
      base_classes = [
        'flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm',
        'ring-offset-background',
        'file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground',
        'placeholder:text-muted-foreground',
        'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2',
        'disabled:cursor-not-allowed disabled:opacity-50'
      ]

      (base_classes + [@class_name]).join(' ').strip
    end
  end
end
