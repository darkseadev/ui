# frozen_string_literal: true

module UI
  # ButtonComponent is a flexible and customizable button component for use in Ruby on Rails applications.
  # It provides various styling options through variants and sizes, and can be easily integrated into views.
  #
  # Features:
  # - Multiple variants: default, destructive, outline, secondary, ghost, and link
  # - Multiple sizes: default, small (sm), large (lg), and icon
  # - Disabled state support
  # - Customizable with additional HTML options
  #
  # Usage:
  #   <%= button(variant: :primary, size: :lg) do %>
  #     Click me!
  #   <% end %>
  class ButtonComponent < ViewComponent::Base
    def initialize(variant: :default, size: :default, disabled: false, **options)
      super
      @variant = variant
      @size = size
      @disabled = disabled
      @options = options
    end

    def call
      options = @options.dup
      options[:class] = [classes, options[:class]].compact.join(' ')
      options[:disabled] = @disabled
      tag.button(content, **options)
    end

    private

    def classes
      [
        base_classes,
        variant_classes,
        size_classes
      ].compact.join(' ')
    end

    def base_classes
      'inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none ring-offset-background gap-2 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0'
    end

    def variant_classes
      case @variant
      when :default
        'bg-primary text-primary-foreground hover:bg-primary/90'
      when :destructive
        'bg-destructive text-destructive-foreground hover:bg-destructive/90'
      when :outline
        'border border-input hover:bg-accent hover:text-accent-foreground'
      when :secondary
        'bg-secondary text-secondary-foreground hover:bg-secondary/80'
      when :ghost
        'hover:bg-accent hover:text-accent-foreground'
      when :link
        'underline-offset-4 hover:underline text-primary'
      end
    end

    def size_classes
      case @size
      when :default
        'h-10 py-2 px-4'
      when :sm
        'h-9 px-3 rounded-md'
      when :lg
        'h-11 px-8 rounded-md'
      when :icon
        'h-10 w-10'
      end
    end
  end
end
