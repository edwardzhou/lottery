# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

bet_input_enabled = false
timer_setted = false
end_time = null
close_time = null

update_time = ->
  if end_time != null
    end_seconds = (end_time.getTime() - (new Date()).getTime()) / 1000
    close_seconds = (close_time.getTime() - (new Date()).getTime()) / 1000
    end_min = Math.floor(end_seconds / 60)
    end_sec = Math.floor(end_seconds % 60)
    close_min = Math.floor(close_seconds / 60)
    close_sec = Math.floor(close_seconds % 60)

    end_str = "0" if end_min < 10
    end_str = end_str + end_min + ":"
    end_str = end_str + "0" if end_sec < 10
    end_str = end_str + end_sec
    endstr = end_str + end_sec

    close_str = "0" if close_min < 10
    close_str = close_str + close_min + ":"
    close_str = close_str + "0" if close_sec < 10
    close_str = close_str + close_sec

    $("#close_time").text(close_str)
    $("#end_time").text(end_str)



on_load_odds = (odds_level) ->
  $("#UserResult").text(odds_level.stat.total_win_after_return)
  end_time = new Date(odds_level.current_lottery.end_time)
  close_time = new Date(odds_level.current_lottery.close_at)
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
  window.setTimeout(load_odds, 10 * 1000)

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
