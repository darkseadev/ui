module UI
  class SelectComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: select_classes, data: { controller: 'select' }, **@options) do
        safe_join([
                    tag.input(type: 'hidden', name: @options[:name], id: @options[:id]),
                    content
                  ])
      end
    end

    private

    def select_classes
      "relative #{@class_name}"
    end
  end

  class SelectTriggerComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.button(class: trigger_classes, data: { action: 'click->select#toggle' }, **@options) do
        safe_join([
                    tag.span(content, data: { select_target: 'triggerText' }),
                    tag.span(class: 'absolute right-3 top-1/2 -translate-y-1/2') do
                      tag.svg(xmlns: 'http://www.w3.org/2000/svg', viewBox: '0 0 20 20', fill: 'currentColor',
                              class: 'w-5 h-5') do
                        tag.path(fill_rule: 'evenodd',
                                 d: 'M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z', clip_rule: 'evenodd')
                      end
                    end
                  ])
      end
    end

    private

    def trigger_classes
      "flex h-10 w-full items-center justify-between rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1 #{@class_name}"
    end
  end

  class SelectContentComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: content_classes, data: { select_target: 'content' }, **@options) do
        content
      end
    end

    private

    def content_classes
      "absolute z-50 w-full min-w-[8rem] overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 #{@class_name}"
    end
  end

  class SelectItemComponent < ViewComponent::Base
    def initialize(value:, class_name: nil, **options)
      @value = value
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: item_classes, data: { action: 'click->select#select', value: @value, select_target: 'item' },
              **@options) do
        safe_join([
                    tag.span(class: 'absolute left-2 flex h-3.5 w-3.5 items-center justify-center') do
                      tag.svg(xmlns: 'http://www.w3.org/2000/svg', viewBox: '0 0 20 20', fill: 'currentColor',
                              class: 'w-4 h-4 hidden') do
                        tag.path(fill_rule: 'evenodd',
                                 d: 'M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.05-.143z', clip_rule: 'evenodd')
                      end
                    end,
                    content
                  ])
      end
    end

    private

    def item_classes
      "relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 hover:bg-accent hover:text-accent-foreground #{@class_name}"
    end
  end

  class SelectLabelComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.span(content, class: label_classes, **@options)
    end

    private

    def label_classes
      "py-1.5 pl-8 pr-2 text-sm font-semibold #{@class_name}"
    end
  end

  class SelectGroupComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: group_classes, **@options) do
        content
      end
    end

    private

    def group_classes
      "#{@class_name}"
    end
  end
end
