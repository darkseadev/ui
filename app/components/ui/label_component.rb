module UI
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
