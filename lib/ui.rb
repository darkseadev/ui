require "ui/version"
require "ui/component_helpers"

module UI
  class Error < StandardError; end

  class Engine < ::Rails::Engine
    initializer "ui.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include UI::ComponentHelpers
      end
    end
  end
end