# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

bet_input_enabled = false
timer_setted = false

on_load_odds = (odds_level) ->
  prev_id = $('.previous_lottery_id').data("id")
  if prev_id != odds_level.previous_lottery.lottery_full_id
    $("#ball_no1").attr("class", "No_" + odds_level.previous_lottery.ball_1)
    $("#ball_no2").attr("class", "No_" + odds_level.previous_lottery.ball_2)
    $("#ball_no3").attr("class", "No_" + odds_level.previous_lottery.ball_3)
    $("#ball_no4").attr("class", "No_" + odds_level.previous_lottery.ball_4)
    $("#ball_no5").attr("class", "No_" + odds_level.previous_lottery.ball_5)
    $("#ball_no6").attr("class", "No_" + odds_level.previous_lottery.ball_6)
    $("#ball_no7").attr("class", "No_" + odds_level.previous_lottery.ball_7)
    $("#ball_no8").attr("class", "No_" + odds_level.previous_lottery.ball_8)
    $('.previous_lottery_id').data("id", odds_level.previous_lottery.lottery_full_id)
    $('.previous_lottery_id').text(odds_level.previous_lottery.lottery_full_id)
    $(".current_lottery_id").text(odds_level.current_lottery.lottery_full_id)

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
  window.setTimeout(load_odds, 10 * 1000)

jQuery ->
  if gon and gon.ball_url
    load_odds();
    #window.setTimeout(load_odds, 1 * 1000)
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
