# frozen_string_literal: true

module UI
  # LabelComponent is a ViewComponent class for rendering customizable label elements.
  #
  # This component allows for the creation of label elements with configurable attributes
  # and styling. It supports setting the 'for' attribute, custom CSS classes, and additional
  # HTML options.
  #
  # @example Basic usage
  #   <%= label(for: 'input_id', class_name: 'custom-class') do %>
  #     Label Text
  #   <% end %>
  #
  # @attr_reader [String, Symbol, nil] for The ID of the form control this label is associated with
  # @attr_reader [String] class_name Additional CSS classes to be applied to the label
  # @attr_reader [Hash] options Additional HTML attributes to be applied to the label
  class LabelComponent < ViewComponent::Base
    def initialize(for: nil, class_name: '', **options)
      super
      @for = binding.local_variable_get(:for)
      @class_name = class_name
      @options = options
    end

    def call
      tag.label(content, **label_options)
    end

    private

    def label_options
      options = @options.dup
      options[:for] = @for if @for
      options[:class] = label_classes
      options
    end

    def label_classes
      base_classes = [
        'text-sm font-medium leading-none',
        'peer-disabled:cursor-not-allowed peer-disabled:opacity-70'
      ]

      (base_classes + [@class_name]).join(' ').strip
    end
  end
end
