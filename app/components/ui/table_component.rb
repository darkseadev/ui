# frozen_string_literal: true

module UI
  # TableOptions module
  # Provides shared attributes and methods for table-related components
  module TableOptions
    attr_reader :bleed, :dense, :grid, :striped

    def table_options
      { bleed: @bleed, dense: @dense, grid: @grid, striped: @striped }
    end
  end

  # TableComponent
  # This component represents the main table structure.
  # It handles the overall table layout and styling, including options for
  # bleed, density, grid lines, and striping.
  #
  # Usage:
  #   <%= table(bleed: true, dense: false, grid: true, striped: true) do %>
  #     <!-- Table content -->
  #   <% end %>
  #
  # Options:
  #   - bleed: (Boolean) Extends table to full width of container
  #   - dense: (Boolean) Reduces vertical padding in cells
  #   - grid: (Boolean) Adds vertical grid lines
  #   - striped: (Boolean) Alternates background color of rows
  #   - class_name: (String) Additional CSS classes for the table
  class TableComponent < ViewComponent::Base
    include TableOptions

    def initialize(bleed: false, dense: false, grid: false, striped: false, class_name: nil, **options)
      super
      super
      @bleed = bleed
      @dense = dense
      @grid = grid
      @striped = striped
      @class_name = class_name
      @options = options
    end

    def call
      tag.div(class: 'flow-root') do
        tag.div(class: table_wrapper_classes, **@options) do
          tag.div(class: table_inner_wrapper_classes) do
            tag.table(class: table_classes) do
              content
            end
          end
        end
      end
    end

    def render_in(view_context, &block)
      view_context.instance_variable_set(:@parent_table_options, table_options)
      super
    end

    private

    def table_wrapper_classes
      "-mx-[--gutter] overflow-x-auto whitespace-nowrap #{@class_name}"
    end

    def table_inner_wrapper_classes
      classes = ['inline-block min-w-full align-middle']
      classes << 'sm:px-[--gutter]' unless @bleed
      classes.join(' ')
    end

    def table_classes
      classes = ['min-w-full text-left text-sm/6 text-foreground']
      classes << 'divide-y divide-border' if @striped
      classes.join(' ')
    end
  end

  # TableHeadComponent
  # This component represents the header section of the table.
  # It handles the styling and rendering of the table header.
  #
  # Usage:
  #   <%= table_head do %>
  #     <!-- Header content -->
  #   <% end %>
  #
  # Options:
  #   - class_name: (String) Additional CSS classes for the header
  class TableHeadComponent < ViewComponent::Base
    include TableOptions

    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
      set_table_options
    end

    def call
      tag.thead(class: head_classes, **@options) do
        content
      end
    end

    private

    def head_classes
      "text-muted-foreground #{@class_name}"
    end

    def set_table_options
      parent_options = @options.delete(:parent_table_options) || {}
      parent_options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end

  # TableBodyComponent
  # This component represents the body section of the table.
  # It handles the rendering of the table body and inherits table options
  # from its parent.
  #
  # Usage:
  #   <%= table_body do %>
  #     <!-- Body content -->
  #   <% end %>
  #
  # Options:
  #   - bleed, dense, grid, striped: (Boolean) Table styling options
  class TableBodyComponent < ViewComponent::Base
    include TableOptions

    def initialize(bleed: false, dense: false, grid: false, striped: false, **options)
      super
      @bleed = bleed
      @dense = dense
      @grid = grid
      @striped = striped
      @options = options
    end

    def call
      tag.tbody do
        content
      end
    end

    def set_table_options
      parent_options = @options.delete(:parent_table_options) || {}
      parent_options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end

  # TableRowComponent
  # This component represents a single row in the table.
  # It handles row-specific styling, including support for linkable rows
  # and striping effects.
  #
  # Usage:
  #   <%= table_row(href: '/path') do %>
  #     <!-- Row content -->
  #   <% end %>
  #
  # Options:
  #   - href: (String) URL for linkable row
  #   - target: (String) Target attribute for linkable row
  #   - title: (String) Title attribute for linkable row
  #   - class_name: (String) Additional CSS classes for the row
  class TableRowComponent < ViewComponent::Base
    include TableOptions

    def initialize(href: nil, target: nil, title: nil, class_name: nil, **options)
      super
      @href = href
      @target = target
      @title = title
      @class_name = class_name
      @options = options
      set_table_options
    end

    def call
      tag.tr(class: row_classes, **@options) do
        content
      end
    end

    private

    def row_classes
      classes = [@class_name]
      classes << 'even:bg-muted' if @striped
      classes << 'hover:bg-accent hover:text-accent-foreground' if @href && @striped
      classes << 'hover:bg-muted' if @href && !@striped
      if @href
        classes << 'has-[[data-row-link][data-focus]]:outline has-[[data-row-link][data-focus]]:outline-2 has-[[data-row-link][data-focus]]:-outline-offset-2 has-[[data-row-link][data-focus]]:outline-ring'
      end
      classes.compact.join(' ')
    end

    def set_table_options
      parent_options = @options.delete(:parent_table_options) || {}
      parent_options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end

  # TableHeaderComponent
  # This component represents a header cell in the table.
  # It handles the styling and rendering of individual header cells,
  # including border and padding adjustments based on table options.
  #
  # Usage:
  #   <%= table_header do %>
  #     Header Cell Content
  #   <% end %>
  #
  # Options:
  #   - class_name: (String) Additional CSS classes for the header cell
  class TableHeaderComponent < ViewComponent::Base
    include TableOptions

    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
      set_table_options
    end

    def call
      tag.th(class: header_classes, **@options) do
        content
      end
    end

    private

    def header_classes
      classes = [@class_name,
                 'border-b border-b-border px-4 py-2 font-medium first:pl-[var(--gutter,theme(spacing.2))] last:pr-[var(--gutter,theme(spacing.2))]']
      classes << 'border-l border-l-border first:border-l-0' if @grid
      classes << 'sm:first:pl-1 sm:last:pr-1' unless @bleed
      classes.join(' ')
    end

    def set_table_options
      parent_options = @options.delete(:parent_table_options) || {}
      parent_options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end

  # TableCellComponent
  # This component represents a data cell in the table.
  # It handles the styling and rendering of individual data cells,
  # including support for linkable cells and various table options.
  #
  # Usage:
  #   <%= table_cell(href: '/path') do %>
  #     Cell Content
  #   <% end %>
  #
  # Options:
  #   - class_name: (String) Additional CSS classes for the cell
  #   - href: (String) URL for linkable cell
  class TableCellComponent < ViewComponent::Base
    include TableOptions

    def initialize(class_name: nil, **options)
      super
      @class_name = class_name
      @options = options
      set_table_options
    end

    def call
      tag.td(class: cell_classes, **@options) do
        link_wrapper(content)
      end
    end

    private

    def cell_classes
      classes = [@class_name,
                 'relative px-4 first:pl-[var(--gutter,theme(spacing.2))] last:pr-[var(--gutter,theme(spacing.2))]']
      classes << 'border-b border-border' unless @striped
      classes << 'border-l border-l-border first:border-l-0' if @grid
      classes << (@dense ? 'py-2.5' : 'py-4')
      classes << 'sm:first:pl-1 sm:last:pr-1' unless @bleed
      classes.join(' ')
    end

    def link_wrapper(content)
      if @href
        safe_join([
                    link_tag,
                    content
                  ])
      else
        content
      end
    end

    def link_tag
      tag.a(
        href: @href,
        target: @target,
        'aria-label': @title,
        tabindex: 0,
        'data-row-link': true,
        class: 'absolute inset-0 focus:outline-none'
      )
    end

    def set_table_options
      parent_options = @options.delete(:parent_table_options) || {}
      parent_options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
