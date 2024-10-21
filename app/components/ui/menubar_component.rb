module UI
  class MenubarComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: menubar_classes, data: { controller: 'menubar' }, **@options) do
        content
      end
    end

    private

    def menubar_classes
      "flex h-10 items-center space-x-1 rounded-md border bg-background p-1 #{@class_name}"
    end
  end

  class MenubarMenuComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: menu_classes, data: { menubar_target: 'menu' }, **@options) do
        content
      end
    end

    private

    def menu_classes
      "relative #{@class_name}"
    end
  end

  class MenubarTriggerComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.button(class: trigger_classes,
                 data: {
                   action: 'click->menubar#toggleMenu mouseover->menubar#showMenuOnHover',
                   menubar_target: 'trigger'
                 },
                 **@options) do
        content
      end
    end

    private

    def trigger_classes
      "flex cursor-default select-none items-center rounded-sm px-3 py-1.5 text-sm font-medium outline-none focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground #{@class_name}"
    end
  end

  class MenubarContentComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: content_classes,
              role: 'menu',
              aria: { orientation: 'vertical' },
              data: {
                menubar_target: 'content',
                side: 'bottom',
                align: 'start',
                state: 'closed'
              },
              **@options) do
        content
      end
    end

    private

    def content_classes
      "absolute left-0 top-full mt-2 z-50 min-w-[192px] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 hidden whitespace-nowrap #{@class_name}"
    end
  end

  class MenubarItemComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: item_classes, role: 'menuitem', data: { action: 'click->menubar#selectItem' }, tabindex: -1,
              **@options) do
        content
      end
    end

    private

    def item_classes
      "relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 whitespace-nowrap #{@class_name}"
    end
  end

  class MenubarSeparatorComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: separator_classes, role: 'separator', **@options)
    end

    private

    def separator_classes
      "-mx-1 my-1 h-px bg-muted #{@class_name}"
    end
  end
end
