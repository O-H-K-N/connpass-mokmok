document.addEventListener('DOMContentLoaded', () => {
  $('.open-new').on('click touchend', () => {
    $('.mask-new').fadeIn();
    $('.modal-new').fadeIn();
  });

  // $('.close').on('click touchend', () => {
  //   $('.mask').fadeOut();
  //   $('.modal').fadeOut();
  // });

  $('.mask-new').on('click touchend', () => {
    $('.mask-new').fadeOut();
    $('.modal-new').fadeOut();
  });
})
