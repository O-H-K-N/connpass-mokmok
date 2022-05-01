document.addEventListener('DOMContentLoaded', () => {
  $('.checked').on('click', () => {
    $('#checked').show();
    $('#sent').hide();
    $(".checked").css({ "color":"black", "background-color":"#f8f9fa" });
    $(".checked").addClass("border border-3 rounded-2")
    $(".sent").css({ "color":"gray", "background-color":"white" });
    $(".sent").removeClass("border border-3 rounded-2")
  })
  $('.sent').on('click', () => {
    $('#checked').hide();
    $('#sent').show();
    $(".sent").css({ "color":"black", "background-color":"#f8f9fa" });
    $(".sent").addClass("border border-3 rounded-2")
    $(".checked").css({ "color":"gray", "background-color":"white" });
    $(".checked").removeClass("border border-3 rounded-2")
  })

  // 未回答のクイズを叩くと回答欄のモーダルが表示される
  $('.open').each(function (index, record) {
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

  // 回答済のクイズを叩くと詳細のモーダルが表示される
  $('.detail').each(function (index, record) {
    var recordId = $(record).attr('id');

    $(`#${recordId}.detail`).on('click touchend', () => {
      $(`#${recordId}.mask`).fadeIn();
      $(`#${recordId}.modal-detail`).fadeIn();
    });

    $(`#${recordId}.close`).on('click touchend', () => {
      $(`#${recordId}.mask`).fadeOut();
      $(`#${recordId}.modal-detail`).fadeOut();
    });

    $(`#${recordId}.mask`).on('click touchend', () => {
      $(`#${recordId}.mask`).fadeOut();
      $(`#${recordId}.modal-detail`).fadeOut();
    });
  })
})
