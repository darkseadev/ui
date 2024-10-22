module UI
  class PopoverComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: popover_classes, data: { controller: 'popover' }, **@options) do
        content
      end
    end

    private

    def popover_classes
      "relative #{@class_name}"
    end
  end

  class PopoverTriggerComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
    end

    def call
      if content.respond_to?(:to_s) && !content.to_s.include?('<')
        content_tag(:button, content, class: trigger_classes, data: { action: 'click->popover#toggle' }, **@options)
      else
        content_tag(:div, class: trigger_classes, data: { action: 'click->popover#toggle' }, **@options) do
          content
        end
      end
    end

    private

    def trigger_classes
      "inline-flex items-center justify-center #{@class_name}"
    end
  end

  class PopoverContentComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: content_classes,
              role: 'menu',
              data: {
                popover_target: 'content',
                state: 'closed'
              },
              **@options) do
        content
      end
    end

    private

    def content_classes
      "absolute z-50 w-72 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none transition-all duration-200 ease-out data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 hidden #{@class_name}"
    end
  end
end
