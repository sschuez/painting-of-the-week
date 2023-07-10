module PagesHelper
  def application_container
    excluded_controllers = %w[]
    excluded_actions = %w[]
    
    unless excluded_controllers.include?(controller.controller_name) && excluded_actions.include?(controller.action_name)
      return 'container'
    end
  end
    
  def narrow_application_container
    excluded_controllers = %w[]
    
    unless excluded_controllers.include?(controller.controller_name)
      return 'narrow-container'
    end
  end
end
