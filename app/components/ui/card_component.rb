# frozen_string_literal: true

module UI
  # CardComponent represents the main container of a card UI element.
  # It provides a flexible structure for creating card-based layouts with
  # customizable styles and options.
  class CardComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
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

  # CardHeaderComponent represents the header section of a card.
  # It's typically used to display a title or introductory content
  # at the top of the card.
  class CardHeaderComponent < ViewComponent::Base
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
      "flex flex-col space-y-1.5 p-6 #{@class_name}"
    end
  end

  # CardFooterComponent represents the footer section of a card.
  # It's commonly used for actions, additional information, or
  # summary content at the bottom of the card.
  class CardFooterComponent < ViewComponent::Base
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
      "flex items-center p-6 pt-0 #{@class_name}"
    end
  end

  # CardContentComponent represents the main content area of a card.
  # It's used to display the primary information or body of the card.
  class CardContentComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
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

  # CardTitleComponent represents the title element within a card.
  # It's typically used in conjunction with CardHeaderComponent to
  # provide a prominent heading for the card's content.
  class CardTitleComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
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

  # CardDescriptionComponent represents a descriptive text element within a card.
  # It's often used to provide additional context or a brief summary
  # of the card's content, typically placed below the title.
  class CardDescriptionComponent < ViewComponent::Base
    def initialize(class_name: nil, **options)
      super
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
