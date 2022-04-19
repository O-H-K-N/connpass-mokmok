document.addEventListener('DOMContentLoaded', () => {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  liff.init({
    liffId: gon.liff_id
  })
  // 他のメソッドを実行できるようになるための作業
  .then(() => {
    // ユーザがログインしているかどうかを確認
    if (!liff.isLoggedIn()) {
      liff.login();
    }
  })
  // idTokenからユーザーIDを取得し、userテーブルに保存するための処理
  .then(() => {
		// liff.getIDToken()でIDトークンを取得
    const idToken = liff.getIDToken()
    console.log(idToken)
    const body =`idToken=${idToken}`
		// コントローラーにIDトークンを渡すリクエストを準備
    const request = new Request('/users', {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        'X-CSRF-Token': token
      },
      method: 'POST',
      body: body
    });
		// コントローラーにリクエストを送る
    fetch(request)
    .then(() => {
      // controllerからレスポンスがきたら、user登録画面にページ遷移
      window.location = '/'
    })
  })
  .catch((err) => {
    // Error happens during initialization
    console.log(err.code, err.message);
  });
})