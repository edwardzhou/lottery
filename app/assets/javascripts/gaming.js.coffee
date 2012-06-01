# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

bet_input_enabled = false
timer_setted = false

on_load_odds = (odds_level) ->
  if odds_level.can_bet
    if !bet_input_enabled
      bet_input_enabled = true
      for rule in odds_level.rules
        do (rule) ->
          $("label[data-odds-rule='" + rule.rule_name + "']").text(rule.odds)
      $(".bet_input").show();
      $(".bet_lock").hide();
  else
    if bet_input_enabled
      bet_input_enabled = false
      $(".odds_label").text("-")
      $(".bet_input").hide();
      $(".bet_lock").show()

load_odds = ->
  $.ajax({url: gon.ball_url+'?_time=' + (new Date()).getTime().toString()}).done( (data) => on_load_odds(data) )
  window.setTimeout(load_odds, 20 * 1000)

jQuery ->
  if gon and gon.ball_url
    window.setTimeout(load_odds, 3 * 1000)
    #$.ajax({url: gon.ball_url}).done( (data) => on_load_odds(data) )
    $(".bet_input").bind("blur", () ->
      value = parseInt($(this).val())
      if isNaN(value) or value <= 0
        value = ""
      $(this).val(value)
    )

  $(".reset").bind("click", () ->
    $(".bet_input").val("");
  )
