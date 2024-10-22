# frozen_string_literal: true

module UI
  # TabsComponent
  # A ViewComponent that represents a tabbed interface.
  # It serves as the main container for the tabbed content.
  class TabsComponent < ViewComponent::Base
    def initialize(default_value: nil, class_name: nil, **options)
      super
      @default_value = default_value
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: tabs_classes, data: { controller: 'tabs', tabs_default_value: @default_value }, **@options) do
        content
      end
    end

    private

    def tabs_classes
      "#{@class_name}"
    end
  end

  # TabsListComponent
  # A ViewComponent that represents the container for tab triggers.
  # It creates a styled list of tab buttons.
  class TabsListComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: list_classes, role: 'tablist', **@options) do
        content
      end
    end

    private

    def list_classes
      "items-center justify-center rounded-lg bg-muted p-1 text-muted-foreground grid w-full grid-cols-2 #{@class_name}"
    end
  end

  # TabsTriggerComponent
  # A ViewComponent that represents an individual tab button.
  # It handles the selection and styling of each tab.
  class TabsTriggerComponent < ViewComponent::Base
    def initialize(value:, class_name: nil, **options)
      super
      @value = value
      @class_name = class_name
      @options = options
    end

    def call
      tag.button(
        content,
        class: trigger_classes,
        role: 'tab',
        data: {
          tabs_target: 'trigger',
          action: 'click->tabs#select',
          state: 'inactive',
          value: @value
        },
        tabindex: -1,
        **@options
      )
    end

    private

    def trigger_classes
      "inline-flex items-center justify-center whitespace-nowrap rounded-md px-3 py-1 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow #{@class_name}"
    end
  end

  # TabsContentComponent
  # A ViewComponent that represents the content area for each tab.
  # It manages the visibility and styling of the content associated with each tab.
  class TabsContentComponent < ViewComponent::Base
    def initialize(value:, class_name: nil, **options)
      super
      @value = value
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(
        content,
        class: content_classes,
        role: 'tabpanel',
        data: {
          tabs_target: 'content',
          state: 'inactive',
          value: @value
        },
        **@options
      )
    end

    private

    def content_classes
      "mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 #{@class_name}"
    end
  end
end
