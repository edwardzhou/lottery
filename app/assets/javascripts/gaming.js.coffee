# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

load_odds = (odds_level) ->
  for rule in odds_level.rules
    do (rule) ->
      $("label[data-odds-rule='" + rule.rule_name + "']").text(rule.odds)
  $(".bet_input").show();
  $(".bet_lock").hide();

jQuery ->
  $.ajax({url: gon.ball_url}).done( (data) => load_odds(data) )
  $(".bet_input").bind("blur", () ->
    value = parseInt($(this).val())
    if isNaN(value) or value <= 0
      value = ""
    $(this).val(value)
  )

  $(".reset").bind("click", () ->
    $(".bet_input").val("");
  )
