# frozen_string_literal: true

module UI
  # Main dialog component that wraps the entire dialog structure
  class DialogComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
    end

    def call
      content_tag(:div, class: dialog_classes, data: { controller: 'dialog' }, **@options) do
        content
      end
    end

    private

    def dialog_classes
      "relative #{@class_name}"
    end
  end

  # Component for the semi-transparent backdrop behind the dialog
  class DialogBackdropComponent < ViewComponent::Base
    def call
      content_tag(:div, '', class: backdrop_classes,
                            data: { dialog_target: 'backdrop', action: 'click->dialog#close', state: 'closed' })
    end

    private

    def backdrop_classes
      'fixed inset-0 z-[2000] bg-black/50 transition-opacity duration-200 ease-in-out opacity-0 data-[state=open]:opacity-100'
    end
  end

  # Component for the element that triggers the dialog to open
  class DialogTriggerComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
    end

    def call
      if content.respond_to?(:to_s) && !content.to_s.include?('<')
        tag.button(content, class: trigger_classes, data: { action: 'click->dialog#toggle' }, **@options)
      else
        tag.div(class: trigger_classes, data: { action: 'click->dialog#toggle' }, **@options) do
          content
        end
      end
    end

    private

    def trigger_classes
      "inline-flex items-center justify-center #{@class_name}"
    end
  end

  # Component for the main content area of the dialog
  class DialogContentComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: content_classes,
              role: 'dialog',
              aria: { modal: true },
              data: {
                dialog_target: 'content',
                state: 'closed'
              },
              **@options) do
        concat(close_button)
        concat(content)
      end
    end

    private

    def content_classes
      "fixed left-[50%] top-[50%] z-[3000] grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg duration-200 transition-all sm:rounded-lg sm:max-w-[425px] #{@class_name} #{animation_classes}"
    end

    def animation_classes
      'opacity-0 scale-95 data-[state=open]:opacity-100 data-[state=open]:scale-100'
    end

    def close_button
      tag.button(
        class: 'absolute top-4 right-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground',
        type: 'button',
        aria: { label: 'Close' },
        data: { dialog_target: 'closeButton', action: 'click->dialog#close' }
      ) do
        tag.svg(
          xmlns: 'http://www.w3.org/2000/svg',
          width: '24',
          height: '24',
          viewBox: '0 0 24 24',
          fill: 'none',
          stroke: 'currentColor',
          stroke_width: '2',
          stroke_linecap: 'round',
          stroke_linejoin: 'round'
        ) do
          concat(tag.line(x1: '18', y1: '6', x2: '6', y2: '18'))
          concat(tag.line(x1: '6', y1: '6', x2: '18', y2: '18'))
        end
      end
    end
  end

  # Component for the header section of the dialog content
  class DialogHeaderComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: header_classes, **@options) do
        content
      end
    end

    private

    def header_classes
      "flex flex-col space-y-1.5 text-center sm:text-left #{@class_name}"
    end
  end

  # Component for the title of the dialog
  class DialogTitleComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
    end

    def call
      tag.h3(class: title_classes, **@options) do
        content
      end
    end

    private

    def title_classes
      "text-lg font-semibold leading-none tracking-tight #{@class_name}"
    end
  end

  # Component for the description text in the dialog
  class DialogDescriptionComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
    end

    def call
      tag.p(class: description_classes, **@options) do
        content
      end
    end

    private

    def description_classes
      "text-sm text-muted-foreground #{@class_name}"
    end
  end

  # Component for the footer section of the dialog content
  class DialogFooterComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: footer_classes, **@options) do
        content
      end
    end

    private

    def footer_classes
      "flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2 #{@class_name}"
    end
  end
end
