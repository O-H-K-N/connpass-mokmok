document.addEventListener('DOMContentLoaded', () => {
  $('#before-text').on('click', () => {
    $('.before-events-field').show();
    $("#before-text").css("color","black");
    $("#before-border").addClass("border-dark")
    $('.after-events-field').hide();
    $("#after-text").css("color","gray");
    $("#after-border").removeClass("border-dark")
  })
  $('#after-text').on('click', () => {
    $('.before-events-field').hide();
    $("#after-text").css("color","black");
    $("#after-border").addClass("border-dark")
    $('.after-events-field').show();
    $("#before-text").css("color","gray");
    $("#before-border").removeClass("border-dark")
  })
})