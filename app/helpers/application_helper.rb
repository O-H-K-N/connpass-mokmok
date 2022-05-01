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

  # 経過時間を表示
  def time_ago(time)
    second = Time.now - time
    if second > 59
      minute = (second / 60).floor
      if minute > 59
        hour = (minute / 60).floor
        if hour > 24
          day = (hour / 24).floor
          return "#{day}日前"
        else
          return "#{hour}時間前"
        end
      else
        return "#{minute}分前"
      end
    else
      return "#{second.floor}秒前"
    end
  end
end
