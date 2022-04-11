document.addEventListener('DOMContentLoaded', () => {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    liff.init({
    liffId: "1657044144-948kja8D"
  })
  .then(() => {
    // ユーザーがログインしているかどうかを確認
    if (!liff.isLoggedIn()) {
      // 開発時、外部ブラウザからアクセスために利用
      liff.login();
    }
  })
  .then(() => {
    // LIFFSDKによって取得された現在のユーザーの生のIDトークンを取得
    const idToken = liff.getIDToken();
    debugger
    const body = `idToken=${idToken}`
    const request = new Request('/users', {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
          'X-CSRF-Token': token
        },
        method: 'POST',
        body: body
      });
    // lineのユーザーIDトークンをcontrollerに送る
    fetch(request)
  })
  .then(() => {
    // controllerからレスポンスがきたら、user登録画面にページ遷移
    window.location = '/homes/index'
  })
})