document.addEventListener('DOMContentLoaded', () => {
  $('.dropdown').each(function (index, record) {
    var recordId = $(record).attr('id');

    // 各記録のメニューボタンをクリックすると、ドロップダウンメニューが表示される
    $(`#${recordId}.dropdown`).on('click touchend', () => {
      $(`#${recordId}.dropdown-content`).fadeIn();
    })

    // 適当に画面をタップすると、開いていたドロップダウンメニューは閉じる
    $(document).on('click touchend', (event) => {
      if (!$(event.target).closest(`#${recordId}.dropdown`).length) {
        $(`#${recordId}.dropdown-content`).fadeOut();
      }
    });
  })
})
