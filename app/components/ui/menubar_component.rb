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
      "inline-flex h-10 items-center space-x-1 rounded-md border bg-background p-1 #{@class_name}"
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
                 tabindex: 0,
                 **@options) do
        content
      end
    end

    private

    def trigger_classes
      "flex cursor-default select-none items-center rounded-sm px-3 py-1.5 text-sm font-medium outline-none focus:bg-accent focus:text-accent-foreground hover:bg-accent hover:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground #{@class_name}"
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
      "absolute left-0 z-50 min-w-max rounded-md border bg-popover p-1 text-popover-foreground shadow-md transition-all duration-200 ease-out data-[state=open]:animate-fade-in data-[state=closed]:animate-fade-out data-[state=open]:opacity-100 data-[state=closed]:opacity-0 data-[side=bottom]:animate-slide-in-from-top data-[side=top]:animate-slide-in-from-bottom hidden #{@class_name}"
    end
  end

  class MenubarItemComponent < ViewComponent::Base
    def initialize(class_name: nil, inset: false, disabled: false, **options)
      @class_name = class_name
      @inset = inset
      @disabled = disabled
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
      classes = "relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground hover:bg-accent hover:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 #{@class_name}"
      classes += ' pl-8' if @inset
      classes += ' opacity-50 pointer-events-none' if @disabled
      classes
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

  class MenubarSubComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: sub_classes, data: { menubar_target: 'sub' }, **@options) do
        content
      end
    end

    private

    def sub_classes
      "relative #{@class_name}"
    end
  end

  class MenubarSubTriggerComponent < ViewComponent::Base
    def initialize(class_name: nil, inset: false, **options)
      @class_name = class_name
      @inset = inset
      @options = options
    end

    def call
      tag.div(class: trigger_classes,
              data: {
                action: 'click->menubar#toggleSubMenu mouseover->menubar#showSubMenuOnHover',
                menubar_target: 'subTrigger'
              },
              tabindex: 0,
              **@options) do
        content + chevron_right_icon
      end
    end

    private

    def trigger_classes
      classes = "flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground hover:bg-accent hover:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground #{@class_name}"
      classes += ' pl-8' if @inset
      classes
    end

    def chevron_right_icon
      tag.svg(xmlns: 'http://www.w3.org/2000/svg', width: '24', height: '24', viewBox: '0 0 24 24', fill: 'none',
              stroke: 'currentColor', stroke_width: '2', stroke_linecap: 'round', stroke_linejoin: 'round', class: 'ml-auto h-4 w-4') do
        tag.polyline(points: '9 18 15 12 9 6')
      end
    end
  end

  class MenubarSubContentComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: content_classes,
              role: 'menu',
              aria: { orientation: 'vertical' },
              data: {
                menubar_target: 'subContent',
                state: 'closed'
              },
              **@options) do
        content
      end
    end

    private

    def content_classes
      "absolute z-50 min-w-max ml-2 rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 #{@class_name}"
    end
  end

  class MenubarCheckboxItemComponent < ViewComponent::Base
    def initialize(class_name: nil, checked: false, **options)
      @class_name = class_name
      @checked = checked
      @options = options
    end

    def call
      tag.div(class: checkbox_item_classes, role: 'menuitemcheckbox', data: { action: 'click->menubar#toggleCheckboxItem' }, tabindex: -1,
              **@options) do
        check_icon + content
      end
    end

    private

    def checkbox_item_classes
      "relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground hover:bg-accent hover:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 #{@class_name}"
    end

    def check_icon
      tag.span(class: "absolute left-2 flex h-3.5 w-3.5 items-center justify-center #{'hidden' unless @checked}") do
        tag.svg(xmlns: 'http://www.w3.org/2000/svg', width: '24', height: '24', viewBox: '0 0 24 24', fill: 'none',
                stroke: 'currentColor', stroke_width: '2', stroke_linecap: 'round', stroke_linejoin: 'round', class: 'h-4 w-4') do
          tag.polyline(points: '20 6 9 17 4 12')
        end
      end
    end
  end

  class MenubarRadioGroupComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: radio_group_classes, role: 'group', **@options) do
        content
      end
    end

    private

    def radio_group_classes
      "#{@class_name}"
    end
  end

  class MenubarRadioItemComponent < ViewComponent::Base
    def initialize(class_name: nil, checked: false, **options)
      @class_name = class_name
      @checked = checked
      @options = options
    end

    def call
      tag.div(class: radio_item_classes, role: 'menuitemradio', data: { action: 'click->menubar#selectRadioItem' }, tabindex: -1,
              **@options) do
        circle_icon + content
      end
    end

    private

    def radio_item_classes
      "relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground hover:bg-accent hover:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 #{@class_name}"
    end

    def circle_icon
      tag.span(class: "absolute left-2 flex h-3.5 w-3.5 items-center justify-center #{'hidden' unless @checked}") do
        tag.svg(xmlns: 'http://www.w3.org/2000/svg', width: '24', height: '24', viewBox: '0 0 24 24',
                fill: 'currentColor', class: 'h-2 w-2') do
          tag.circle(cx: '12', cy: '12', r: '8')
        end
      end
    end
  end

  class MenubarShortcutComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.span(class: shortcut_classes, **@options) do
        content
      end
    end

    private

    def shortcut_classes
      "ml-auto text-xs tracking-widest text-muted-foreground #{@class_name}"
    end
  end
end
