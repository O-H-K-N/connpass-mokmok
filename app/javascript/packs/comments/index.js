document.addEventListener('DOMContentLoaded', () => {
  $('.comment-dropdown').each(function (index, comment) {
    var commentId = $(comment).attr('id');

    // 各コメントのメニューボタンをクリックすると、ドロップダウンメニューが表示される
    $(`#${commentId}.comment-dropdown`).on('click touchend', () => {
      $(`#${commentId}.comment-dropdown-content`).fadeIn();
    })

    // 適当に画面をタップすると、開いていたドロップダウンメニューは閉じる
    $(document).on('click touchend', (event) => {
      if (!$(event.target).closest(`#${commentId}.comment-dropdown`).length) {
        $(`#${commentId}.comment-dropdown-content`).fadeOut();
      }
    })
  })
})
