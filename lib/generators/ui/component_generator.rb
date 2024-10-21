module UI
  class ComponentGenerator < Rails::Generators::Base
    source_root File.expand_path('../../templates', __dir__)
    argument :component_name, type: :string

    def create_component_file
      template 'component.rb.erb', "app/components/ui/#{file_name}_component.rb"
    end

    private

    def file_name
      component_name.underscore
    end

    def class_name
      component_name.camelize
    end
  end
end
