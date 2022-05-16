module ApplicationHelper
  # タブタイトル
  def page_title(page_title = '')
    base_title = t('defaults.app_name')

		page_title.empty? ? base_title : page_title + " | " + base_title
  end

  # 新規登録・ログイン後のフッターメニュー
  def footer_menu(target_action)
    return unless params[:action] == target_action

    'text-dark bg-light border border-3 rounded-2'
  end
end
