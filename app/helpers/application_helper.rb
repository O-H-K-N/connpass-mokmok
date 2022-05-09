module ApplicationHelper
  # 手紙を扱うページのヘッダーメニュー
  def letter_menu(target_action)
    return unless params[:action] == target_action

    'text-dark bg-light border border-3 rounded-2'
  end

  # 新規登録・ログイン後のフッターメニュー
  def footer_menu(target_controller)
    return unless params[:controller] == target_controller

    'text-dark bg-light border border-3 rounded-2'
  end
end
