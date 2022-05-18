document.addEventListener('DOMContentLoaded', () => {
  $('#all-text').on('click', () => {
    $('.events-field').show();
    $("#all-text").css("color","black");
    $("#all-border").addClass("border-dark")
    $('.first-events-field').hide();
    $("#first-text").css("color","gray");
    $("#first-border").removeClass("border-dark")
    $('.second-events-field').hide();
    $("#second-text").css("color","gray");
    $("#second-border").removeClass("border-dark")
    $('.third-events-field').hide();
    $("#third-text").css("color","gray");
    $("#third-border").removeClass("border-dark")
  })
  $('#first-text').on('click', () => {
    $('.first-events-field').show();
    $("#first-text").css("color","black");
    $("#first-border").addClass("border-dark")
    $('.events-field').hide();
    $("#all-text").css("color","gray");
    $("#all-border").removeClass("border-dark")
    $('.second-events-field').hide();
    $("#second-text").css("color","gray");
    $("#second-border").removeClass("border-dark")
    $('.third-events-field').hide();
    $("#third-text").css("color","gray");
    $("#third-border").removeClass("border-dark")
  })
  $('#second-text').on('click', () => {
    $('.second-events-field').show();
    $("#second-text").css("color","black");
    $("#second-border").addClass("border-dark")
    $('.events-field').hide();
    $("#all-text").css("color","gray");
    $("#all-border").removeClass("border-dark")
    $('.first-events-field').hide();
    $("#first-text").css("color","gray");
    $("#first-border").removeClass("border-dark")
    $('.third-events-field').hide();
    $("#third-text").css("color","gray");
    $("#third-border").removeClass("border-dark")
  })
  $('#third-text').on('click', () => {
    $('.third-events-field').show();
    $("#third-text").css("color","black");
    $("#third-border").addClass("border-dark")
    $('.events-field').hide();
    $("#all-text").css("color","gray");
    $("#all-border").removeClass("border-dark")
    $('.first-events-field').hide();
    $("#first-text").css("color","gray");
    $("#first-border").removeClass("border-dark")
    $('.second-events-field').hide();
    $("#second-text").css("color","gray");
    $("#second-border").removeClass("border-dark")
  })
})