module UI
  module ComponentHelpers
    UI::Engine.config.eager_load_namespaces.each do |namespace|
      namespace.eager_load!
    end

    UI::Engine.config.paths['app/components'].eager_load!

    UI::Engine.config.paths['app/components'].each do |path|
      Dir["#{path}/**/*_component.rb"].each do |component_file|
        require_dependency component_file
      end
    end

    UI::Engine.config.paths['app/components'].each do |path|
      Dir["#{path}/**/*_component.rb"].each do |component_file|
        component_name = File.basename(component_file, '.rb').sub(/_component$/, '')
        component_class = "UI::#{component_name.camelize}Component".constantize

        # Define CamelCase method
        define_method(component_name.camelize) do |*args, &block|
          render(component_class.new(*args), &block)
        end

        # Define snake_case method
        define_method(component_name.underscore) do |*args, &block|
          render(component_class.new(*args), &block)
        end
      end
    end
  end
end
