document.addEventListener('DOMContentLoaded', () => {
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  liff.init({
    liffId: gon.liff_id
  })
    .then(() => {
      if (!liff.isLoggedIn()) {
        liff.login();
      }
    })
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
      .then(response => {
        return response.json().then(response_user => {
          const user = response_user;
          // キーワードに関するもくもく会一覧ページに遷移
          window.location = `/users/${user.id}/events`
        })
      })
    })
    .catch((err) => {
      console.log(err.code, err.message);
    });
})