# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

bet_input_enabled = false
timer_setted = false
end_time = null
close_time = null
start_time = null
refresh_time = 20
c_type = 0
c_odds = 0
c_bet_name = ""
c_bet_count = 0

formatNumber = (num) ->
  s = parseFloat(num)
  s = s + ""
  s = s + ".0" if s.indexOf(".") < 0
  s = s + "0" if /\.\d$/.test(s)
  s = s.replace(/(\d)(\d{3}(\.|,))/, "$1,$2") while /\d{4}(\.|,)/.test(s)
  s

compute_p = (n) ->
  sum = 1
  while n > 0
    sum = sum * n
    n = n - 1

  sum


compute_c = (n, m) ->
  return 0 if n < m
  result = compute_p(n) / (compute_p(m) * compute_p(n-m))

calc_c_type = () ->
  selected_num_count = $(".bet_input_c").filter("[checked]").size()
  selected_num_text = ""
  nums = []
  $(".bet_input_c").filter("[checked]").each (index) ->
    s = $(this).val()
    s = "0" + s if s.length == 1
    nums.push s
  selected_num_text = nums.join(", ")
  selected_num_text = "(共 " + selected_num_count + "个) " + selected_num_text if selected_num_count > 0
  $("#picked_nums").text(selected_num_text)

  bet_num = compute_c(selected_num_count, c_type)
  c_bet_count = bet_num
  if bet_num == 0
    $(".sum_info").text("0")
    return

  max_credit_per_bet = Math.ceil( gon.available_credit / bet_num )
  $("#ball11_c_credit").attr("max", max_credit_per_bet)
  $("#max_credit_per_bet").text(max_credit_per_bet)

  $("#total_bet_num").text(bet_num)
  total_credit = bet_num * parseInt($(".bet_input_credit").val())
  possible_win_credit = total_credit * c_odds
  $("#total_bet_credit").text( formatNumber( total_credit ) )
  #$("#total_possible_win_credit").text( formatNumber( possible_win_credit ) )

  $(".bet_input_c").not("[checked]").attr("disabled", selected_num_count >= 8)

parseDate = (date_str) ->
  the_date = new Date(date_str)
  return the_date unless isNaN(the_date)
  date_str = date_str.replace(/-/g, "/").replace(/\+08:00/, "+0800")
  return new Date(date_str)


update_time = ->
  if end_time != null
    end_seconds = Math.ceil((end_time.getTime() - (new Date()).getTime()) / 1000)
    close_seconds = Math.ceil( (close_time.getTime() - (new Date()).getTime()) / 1000 )
    if close_seconds > 600
      close_seconds = (start_time.getTime() - (new Date()).getTime()) / 1000
    end_min = Math.floor(end_seconds % 3600 / 60)
    end_sec = Math.floor(end_seconds % 60)
    end_hour = Math.floor(end_seconds / 3600)
    close_min = Math.floor(close_seconds % 3600 / 60)
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

    #if (end_seconds <=0 or close_seconds <=0) and (refresh_time > 4)
    #  refresh_time = 4
    if (0 == close_seconds - 1) and (refresh_time > 6)
      refresh_time = 6
    if (0 == end_seconds - 1) and (refresh_time > 6)
      refresh_time = 6

    refresh_time = refresh_time - 1
    if refresh_time <= 0
      refresh_time = 0
      load_odds()

    $("#Update_Time").text(refresh_time)

on_load_odds = (odds_level) ->
  $("#UserResult").text(odds_level.stat.total_win_after_return)
  gon.available_credit = odds_level.user.available_credit
  gon.total_credit = odds_level.user.total_credit
  $("#available_credit").text(formatNumber(gon.available_credit))
  $("#total_credit").text(formatNumber(gon.total_credit))
  end_time = parseDate(odds_level.current_lottery.end_time)
  close_time = parseDate(odds_level.current_lottery.close_at)
  start_time = parseDate(odds_level.current_lottery.start_time)
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
      $(".submit_btn").attr("disabled", false)
      bet_input_enabled = true
      for rule in odds_level.rules
        do (rule) ->
          $("label[data-odds-rule='" + rule.rule_name + "']").text(rule.odds)
          $("input[data-odds-rule='" + rule.rule_name + "']").data("odds", rule.odds)

      $(".bet_input").show();
      $(".bet_lock").hide();
  else
    if bet_input_enabled
      $(".submit_btn").attr("disabled", true)
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
        alert "本注最大投注額度爲 " + $(this).attr("max")
        value = $(this).attr("max")

      $(this).val(value)
    )

    $("#bet_form").bind "submit", =>
      total = 0.0
      total_possible_win = 0.0
      total_items = 0
      $(".bet_input").each (index)->
        value = parseInt($(this).val())
        unless isNaN(value)
          total = total + value
          total_items = total_items + 1
          total_possible_win = total_possible_win + value * parseFloat($(this).data("odds"))

      if total == 0.0
        alert "请先投注!"
        return false
      else if total > gon.available_credit
        alert "不能投注: 總投注金額 " + total + " 大于可用金額 " + gon.available_credit
        return false
      else
        s = total_items + " 注, 總投注金額 " + total + ", 可赢金額 " + total_possible_win
        return confirm(s)

    $("#bet_c_form").bind "submit", =>
      total = $("#total_bet_credit").text()
      total_possible_win = 0.0
      total_items = 0
      bet_type_c = $(".bet_type_c").filter("[checked]")
      if c_bet_count == 0
        msg = bet_type_c.data("c-type") + " 至少必需选择 " + bet_type_c.data("c-value") + " 个号码!"
        alert(msg)
        return false
#      else if total > gon.available_credit
#        alert "不能投注: 總投注金額 " + total + " 大于可用金額 " + gon.available_credit
#        return false
      else
        s = bet_type_c.data("c-type") + " 共 " + c_bet_count + " 组, 總投注金額 " + total + "?"
        return confirm(s)

  $(".reset").bind("click", () ->
    $(".bet_input").val("")
    $(".sum_info").text("0")
  )

  $(".bet_type_c").bind("click", () ->
    $(".bet_input_c").attr("disabled", false).attr("checked", false)
    $(".sum_info").text("0")
    $(".bet_input").attr("disabled", false).val(10)
    c_type = $(this).data("c-value")
    c_odds = parseFloat($(this).data("odds"))
    c_bet_name = $(this).data("c-type")
    $("#bet_name").text(c_bet_name)
  )

  $("#ball11_c_credit").bind "blur", =>
    calc_c_type()

  $(".bet_input_c").bind("click", =>
    calc_c_type()
  )


