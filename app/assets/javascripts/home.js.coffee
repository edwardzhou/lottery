# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



jQuery ->
  if $("#bet_list").size() > 0
    $("#bet_list").jqGrid( {
      url: gon.page_json_url
      datatype: 'json',
      mtype: 'GET',
      colModel: [
        {name: '_id', index: '_id', label: "投注號", width: 180, sortable: false}
        {name: 'username', index: 'user_id', label: "用戶", width: 60, sortable: false}
        {name: 'bet_time', index: 'bet_time', label: "投注時間", width: 130, formatter: "date", formatoptions: {srcformat: 'Y-m-d H:i:s',newformat : 'Y-m-d H:i:s'}}
        {name: 'lottery_full_id', index: 'lottery_full_id', label: "彩票期數", width: 90}
        {name: 'bet_rule_name', index: 'bet_rule_name', label: "投注", width: 180}
        {name: 'credit', index: 'credit', label: "投注金額", width: 70}
        {name: 'odds', index: 'odds', label: "賠率", width: 70}
        {name: 'possible_win_credit', index: 'possible_win_credit', label: "可贏金額", width: 80}
        {name: 'user_return', index: 'user_return', label: "退水", width: 70}
        {name: 'result', index: 'result', label: "输赢", width: 70}
      ],
      jsonReader : {
      root:"rows",
      repeatitems: false,
      id: "_id"
      },
      pager: '#pager',
      rowNum: 40,
      rowList:[20, 40, 60, 100, 200],
      sortname: 'bet_time',
      sortorder: 'desc',
      viewrecords: true,
      gridview: true,
      caption: '下注明細',
      resizable: true,
      height: 350,
      #width: 900,
      id: "_id"
      #autowidth: true,
      footerrow : true,
      userDataOnFooter : true,
      #altRows : true
      }

    );

  if $("#uds_list").size() > 0
    $("#uds_list").jqGrid( {
      url: gon.page_json_url
      datatype: 'json',
      mtype: 'GET',
      colModel: [
        {name: 'stat_date', index: 'stat_date', label: "日期", width: 130}
        {name: 'total_bet_credit', index: 'total_bet_credit', label: "投注额", width: 70}
        {name: 'total_win', index: 'total_win', label: "输赢", width: 100}
        {name: 'total_return', index: 'total_return', label: "退水", width: 70}
        {name: 'total_win_after_return', index: 'total_win_after_return', label: "退水后结果", width: 100}
      ],
      jsonReader : {
      root:"rows",
      repeatitems: false,
      id: "_id"
      },
      pager: '#pager',
      rowNum: 40,
      #rowList:[40],
      sortname: 'stat_time',
      sortorder: 'asc',
      viewrecords: true,
      gridview: true,
      caption: '结算历史',
      resizable: true,
      height: 350,
      width: 500,
      id: "_id"
      #autowidth: true,
      #footerrow : true,
      #userDataOnFooter : true,
      #altRows : true
      }

    );

  if $("#history_list").size() > 0
    $("#history_list").jqGrid( {
      url: gon.page_json_url
      datatype: 'json',
      mtype: 'GET',
      colModel: [
        {name: 'lottery_full_id', label: "期數", width: 100, sortable: false}
        {name: 'end_time', label: "開獎時間", width: 120, sortable: false}
        {name: 'ball_1', label: "1", width: 30, height:50, sortable: false}
        {name: 'ball_2', label: "2", width: 30, sortable: false}
        {name: 'ball_3', label: "3", width: 30, sortable: false}
        {name: 'ball_4', label: "4", width: 30, sortable: false}
        {name: 'ball_5', label: "5", width: 30, sortable: false}
        {name: 'ball_6', label: "6", width: 30, sortable: false}
        {name: 'ball_7', label: "7", width: 30, sortable: false}
        {name: 'ball_8', label: "8", width: 30, sortable: false}
        {name: 'sum', label: "總和", width: 35, sortable: false}
        {name: 'sum_big_small', label: "大小", width: 35, sortable: false}
        {name: 'sum_even_odd', label: "單雙", width: 35, sortable: false}
        {name: 'sum_trail_big_small', label: "尾大小", width: 50, sortable: false}
        {name: 'dragon_tiger', label: "龍虎", width: 40, sortable: false}
      ],
      jsonReader : {
      root:"rows",
      repeatitems: false,
      id: "_id"
      },
      pager: '#pager',
      rowNum: 20,
      rowList:[20, 40, 60, 100],
      sortname: 'stat_time',
      sortorder: 'asc',
      viewrecords: true,
      gridview: true,
      caption: '開獎历史',
      resizable: true,
      height: 500,
      #width: 600,
      id: "_id"

    })

    jQuery("#history_list").jqGrid('setGroupHeaders', {
      useColSpanStyle: false,
      groupHeaders: [
        {startColumnName: "ball_1", numberOfColumns: 8, titleText: "<em>開出號碼</em>"},
        {startColumnName: "sum", numberOfColumns: 4, titleText: "<em>總和</em>"}
      ]
    })



  #  password_validate = (value, element) ->
#    result = this.optional(element) || value.length >= 6 && /\d/.test(value) && /[a-z]/i.test(value);
#    if !result
#      element.value = ""
#      validator = this
#      setTimeout( ()=>
#        validator.blockFocusCleanup = true
#        element.focus()
#        validator.blockFocusCleanup = false
#      ,1)
#    return result
#
#  jQuery.validator.addMethod("password", password_validate, "Your password must be at least 6 characters long and contain at least one number and one character.")
#
  if $("#change_password_form").size() > 0
    $("#change_password_form").validate()


  if $("#dialog-message").size() > 0
    dlg = $("#dialog-message").dialog( {
      resizable: false,
      height: 500,
      width: 850,
      modal: true
      buttons: {
        "同意": ->
          $(this).dialog("close")
          window.location.href = $(".menu_ball9").attr("href")
        ,
        "不同意": ->
          $(this).dialog("close")
          $(".but_7").click()
      }
    })
    dlg.dialog("open")