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

  $('#letter-text').on('click', () => {
    $('.letter-field').show();
    $("#letter-text").css("color","black");
    $("#letter-border").addClass("border-dark")
    $('.record-field').hide();
    $("#record-text").css("color","gray");
    $("#record-border").removeClass("border-dark")
  })
  $('#record-text').on('click', () => {
    $('.letter-field').hide();
    $("#record-text").css("color","black");
    $("#record-border").addClass("border-dark")
    $('.record-field').show();
    $("#letter-text").css("color","gray");
    $("#letter-border").removeClass("border-dark")
  })

})