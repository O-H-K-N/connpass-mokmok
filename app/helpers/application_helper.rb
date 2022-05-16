module ApplicationHelper
  # タブタイトル
  def page_title(page_title = '')
    base_title = t('defaults.app_name')

		page_title.empty? ? base_title : page_title + " | " + base_title
  end

  # OGP設定
  def default_meta_tags
    {
      site:'connpassもくもく会',
      title: ' connpassのもくもく会に参加しよう！',
      reverse: true,
      charset: 'utf-8',
      description: 'connpassに登録されている簡単にもくもく会を検索・確認できるアプリ',
      keywords: 'connpass, もくもく会,',
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('app_logo_3.ico')},
        { href: image_url('app_logo_3.ico'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary',
      }
    }
  end

  # 新規登録・ログイン後のフッターメニュー
  def footer_menu(target_action)
    return unless params[:action] == target_action

    'text-dark bg-light border border-3 rounded-2'
  end
end
