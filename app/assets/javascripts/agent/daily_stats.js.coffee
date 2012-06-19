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
      rowNum: 20,
      rowList:[20, 50, 100],
      sortname: 'stat_time',
      sortorder: 'asc',
      viewrecords: true,
      gridview: true,
      caption: '结算历史',
      resizable: true,
      height: 250,
      width: 700,
      id: "_id",
      onSelectRow: (ids) ->
        detail_url = gon.agent_daily_stats_path + "/" + ids + "/detail_stat"
        if ids == null
          ids = 0
          if jQuery("#agent_uds_list_detail").jqGrid("getGridParam", "records") > 0
            jQuery("#agent_uds_list_detail").jqGrid("setGridParam", {url: detail_url, page: 1 } )
            jQuery("#agent_uds_list_detail").trigger('reloadGrid');
          end
        else
          jQuery("#agent_uds_list_detail").jqGrid("setGridParam", {url: detail_url, page: 1 } )
          jQuery("#agent_uds_list_detail").trigger('reloadGrid');

        #alert ids
    });


    $("#agent_uds_list_detail").jqGrid( {
      url: gon.page_json_url
      datatype: 'json',
      mtype: 'GET',
      colModel: [
        {name: 'username', index: 'username', label: "日期", width: 80},
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
      rowNum: 20,
      rowList:[20, 50, 100],
      sortname: 'stat_time',
      sortorder: 'asc',
      viewrecords: true,
      gridview: true,
      caption: '结算明细',
      resizable: true,
      height: 250,
      width: 700,
      id: "_id",
      loadComplete: (data)->
        #alert "loadComplete"
        $("#detail").show("highlight", {}, 1000)
    })
