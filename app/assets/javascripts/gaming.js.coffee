# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

bet_input_enabled = false
timer_setted = false
end_time = null
close_time = null
refresh_time = 20

update_time = ->
  if end_time != null
    end_seconds = (end_time.getTime() - (new Date()).getTime()) / 1000
    close_seconds = (close_time.getTime() - (new Date()).getTime()) / 1000
    end_min = Math.floor(end_seconds / 60)
    end_sec = Math.floor(end_seconds % 60)
    end_hour = Math.floor(end_seconds / 3600)
    close_min = Math.floor(close_seconds / 60)
    close_sec = Math.floor(close_seconds % 60)
    close_hour = Math.floor(close_seconds / 3600)

    end_str = ""
    if end_seconds > 3600
      end_str = end_str + "0" if end_hour < 10
      end_str = end_str + end_hour + ":"

    if end_seconds > 0
      end_str = end_str + "0" if end_min < 10
      end_str = end_str + end_min + ":"
      end_str = end_str + "0" if end_sec < 10
      end_str = end_str + end_sec
    else
      end_str = "00:00"

    close_str = ""
    if close_seconds > 3600
      close_str = close_str + "0" if close_hour < 10
      close_str = close_str + close_hour + ":"

    if close_seconds > 0
      close_str = close_str + "0" if close_min < 10
      close_str = close_str + close_min + ":"
      close_str = close_str + "0" if close_sec < 10
      close_str = close_str + close_sec
    else
      close_str = "00:00"

    $("#close_time").text(close_str)
    $("#end_time").text(end_str)

    if close_seconds > 600
      $("#close_title").text("距離開盤：")
    else
      $("#close_title").text("距離封盤：")

    refresh_time = refresh_time - 1
    if refresh_time <= 0
      refresh_time = 0
      load_odds()

    $("#Update_Time").text(refresh_time)

on_load_odds = (odds_level) ->
  $("#UserResult").text(odds_level.stat.total_win_after_return)
  end_time = new Date(odds_level.current_lottery.end_time)
  close_time = new Date(odds_level.current_lottery.close_at)
  refresh_time = parseInt(odds_level.refresh_time)
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
    $(".previous_lottery_id").data("id", odds_level.previous_lottery.lottery_full_id)
    $(".previous_lottery_id").text(odds_level.previous_lottery.lottery_full_id)
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
  #window.setTimeout(load_odds, 10 * 1000)

jQuery ->
  if gon and gon.ball_url
    load_odds();
    window.setInterval(update_time, 1 * 1000)
    #window.setTimeout(load_odds, 1 * 1000)
    #$.ajax({url: gon.ball_url}).done( (data) => on_load_odds(data) )
    $(".bet_input").bind("blur", () ->
      value = parseInt($(this).val())
      if isNaN(value) or value <= 0
        value = ""
      else if value > parseInt($(this).attr("max"))
        alert "本注最大投注额度为 " + $(this).attr("max")
        value = $(this).attr("max")

      $(this).val(value)
    )

  $(".reset").bind("click", () ->
    $(".bet_input").val("");
  )
