document.addEventListener('DOMContentLoaded', () => {
  // メニューボタンをクリックすると、ドロップダウンメニューが表示される
  $('.dropdown').on('click touchend', () => {
    $('.dropdown-content').fadeIn();
  })

  // 適当に画面をタップすると、開いていたドロップダウンメニューは閉じる
  $(document).on('click touchend', (event) => {
    if (!$(event.target).closest('.dropdown').length) {
      $('.dropdown-content').fadeOut();
    }
  })
})
