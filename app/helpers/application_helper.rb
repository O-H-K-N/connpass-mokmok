module ApplicationHelper
  def footer_menu(target_controller)
    return unless params[:controller] == target_controller

    'text-dark bg-light'
  end
end
