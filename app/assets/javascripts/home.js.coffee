# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  if $("#bet_list")
    $("#bet_list").jqGrid( {
      url: gon.page_json_url
      datatype: 'json',
      mtype: 'GET',
      colModel: [
        {name: '_id', index: '_id', label: "投注号", width: 180, sortable: false}
        {name: 'bet_time', index: 'bet_time', label: "投注时间", width: 130, formatter: "date", formatoptions: {srcformat: 'Y-m-d H:i:s',newformat : 'Y-m-d H:i:s'}}
        {name: 'lottery_full_id', index: 'lottery_full_id', label: "彩票期数", width: 90}
        {name: 'bet_rule_name', index: 'bet_rule_name', label: "投注", width: 100}
        {name: 'credit', index: 'credit', label: "投注金额", width: 70}
        {name: 'odds', index: 'odds', label: "赔率", width: 70}
        {name: 'possible_win_credit', index: 'possible_win_credit', label: "可赢金额", width: 80}
        {name: 'total_return', index: 'total_return', label: "退水", width: 70}
      ],
      jsonReader : {
      root:"rows",
      repeatitems: false,
      id: "_id"
      },
      pager: '#pager',
      rowNum: 20,
      rowList:[20,40,60],
      sortname: 'bet_time',
      sortorder: 'desc',
      viewrecords: true,
      gridview: true,
      caption: '本期下注明细',
      resizable: true,
      height: 350,
      id: "_id"
      #autowidth: true,
      footerrow : true,
      userDataOnFooter : true,
      #altRows : true
      }

    );