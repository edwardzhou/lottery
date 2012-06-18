# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



jQuery ->
  if $("#agent_uds_list").size() > 0
    $("#agent_uds_list").jqGrid( {
      url: gon.page_json_url
      datatype: 'json',
      mtype: 'GET',
      colModel: [
        {name: 'stat_date', index: 'stat_date', label: "日期", width: 130},
        {name: 'total_agent_return', index: 'total_agent_return', label: "代理水费", width: 100},
        {name: 'total_bet_credit', index: 'total_bet_credit', label: "用户投注", width: 70},
        {name: 'total_win', index: 'total_win', label: "用户输赢", width: 100},
        {name: 'total_return', index: 'total_return', label: "用户退水", width: 70},
        {name: 'total_win_after_return', index: 'total_win_after_return', label: "用户退水后结果", width: 100}
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
      }
    );

