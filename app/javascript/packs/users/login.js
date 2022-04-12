document.addEventListener('DOMContentLoaded', () => {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  liff.init({
    liffId: '1657044144-948kja8D'
  })
  // 他のメソッドを実行できるようになるための作業
  .then(() => {
    debugger
    if (!liff.isLoggedIn()) {
      liff.login();
    }
  })
  // idTokenからユーザーIDを取得し、userテーブルに保存するための処理
  .then(() => {
    const idToken = liff.getIDToken()
    console.log(idToken)
    const body =`idToken=${idToken}`
    const request = new Request('/users', {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        'X-CSRF-Token': token
      },
      method: 'POST',
      body: body
    });
    fetch(request)
  })
  .then(() => {
    // controllerからレスポンスがきたら、user登録画面にページ遷移
    window.location = '/users/new'
  })
  .catch((err) => {
    // Error happens during initialization
    console.log(err.code, err.message);
  });
})