document.addEventListener('DOMContentLoaded', () => {
  const name = document.getElementById('name');
  const picture = document.getElementById('picture');
  liff.init({
    liffId: gon.liff_id
  })
    .then(() => {
      liff.getProfile()
        .then(user => {
          if (typeof user.displayName !== 'undefined') {
            name.innerText = user.displayName;
          }
          if (typeof user.pictureUrl !== 'undefined') {
            picture.src = user.pictureUrl;
          }
        })
    })
})