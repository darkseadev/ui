module UI
  module ComponentHelpers
    def self.included(base)
      base.class_eval do
        Dir[Rails.root.join('app', 'components', 'ui', '**', '*_component.rb')].each do |component_file|
          require_dependency component_file

          classes = UI.constants.map { |c| UI.const_get(c) }
                      .select { |c| c.is_a?(Class) && c < ViewComponent::Base }

          classes.each do |component_class|
            component_name = component_class.name.demodulize.sub(/Component$/, '')

            # Define CamelCase method
            define_method(component_name) do |*args, **kwargs, &block|
              if instance_variable_defined?(:@parent_table_options)
                kwargs[:parent_table_options] =
                  @parent_table_options
              end
              render(component_class.new(*args, **kwargs), &block)
            end

            # Define snake_case method
            define_method(component_name.underscore) do |*args, **kwargs, &block|
              if instance_variable_defined?(:@parent_table_options)
                kwargs[:parent_table_options] =
                  @parent_table_options
              end
              render(component_class.new(*args, **kwargs), &block)
            end
          end
        end
      end
    end
  end
end

ActiveSupport.on_load(:action_view) do
  include UI::ComponentHelpers
end
