module UI
  class CardComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: card_classes, **@options) do
        content
      end
    end

    private

    def card_classes
      "rounded-lg border bg-card text-card-foreground shadow-sm #{@class_name}"
    end
  end

  class CardHeaderComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
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
      "flex flex-col space-y-1.5 p-6 #{@class_name}"
    end
  end

  class CardFooterComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
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
      "flex items-center p-6 pt-0 #{@class_name}"
    end
  end

  class CardContentComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: content_classes, **@options) do
        content
      end
    end

    private

    def content_classes
      "p-6 pt-0 #{@class_name}"
    end
  end

  class CardTitleComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.h3(content, class: title_classes, **@options)
    end

    private

    def title_classes
      "text-2xl font-semibold leading-none tracking-tight #{@class_name}"
    end
  end

  class CardDescriptionComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      @class_name = class_name
      @options = options
    end

    def call
      tag.p(content, class: description_classes, **@options)
    end

    private

    def description_classes
      "text-sm text-muted-foreground #{@class_name}"
    end
  end
end
