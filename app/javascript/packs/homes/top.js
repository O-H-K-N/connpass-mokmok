document.addEventListener('DOMContentLoaded', () => {
  const name = document.getElementById('name');
  const picture = document.getElementById('picture');

  liff.init({
    liffId: gon.liff_id
  })
  .then(() => {
    liff.getProfile()
    .then(user => {
      // Lineのユーザー名が取得できていたら、表示する
      if (typeof user.displayName !== 'undefined') {
        name.innerText = user.displayName;
      }
      // Lineのプロフィール画像が取得できていたら、表示する
      if (typeof user.pictureUrl !== 'undefined') {
        picture.src = user.pictureUrl;
      }
    })
  })
})