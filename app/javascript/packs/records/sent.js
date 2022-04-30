document.addEventListener('DOMContentLoaded', () => {
  // 任意のクイズを叩くと詳細or解答欄のモーダルが表示される
  $('.open').each(function (sent, record) {
    var recordId = $(record).attr('id');

    $(`#${recordId}.open`).on('click touchend', () => {
      $(`#${recordId}.mask`).fadeIn();
      $(`#${recordId}.modal`).fadeIn();
    });

    $(`#${recordId}.close`).on('click touchend', () => {
      $(`#${recordId}.mask`).fadeOut();
      $(`#${recordId}.modal`).fadeOut();
    });

    $(`#${recordId}.mask`).on('click touchend', () => {
      $(`#${recordId}.mask`).fadeOut();
      $(`#${recordId}.modal`).fadeOut();
    });
  })
})
