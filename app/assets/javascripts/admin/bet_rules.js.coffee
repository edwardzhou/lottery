# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#bet_rules_list").jqGrid( {
    url: gon.page_json_url
    datatype: 'json',
    mtype: 'GET',
    colModel: [
      {name: 'rule_id', index: 'rule_id', label: "规则标示", width: 100}
      {name: 'rule_name', index: 'rule_name', label: "规则名称", width: 100}
      {name: 'odds_type', index: 'odds_type', label: "赔率类型", width: 100}
      {name: 'sort_index', index: 'sort_index', label: "排序", width: 60}
      {name: 'edit_url', index: '', label: " ", width: 60, sortable: false}
      {name: 'delete_url', index: '', label: " ", width: 60, sortable: false}
    ],
    jsonReader : {
    root:"rows",
    repeatitems: false,
    id: "_id"
    },
    pager: '#pager',
    rowNum: 20,
    rowList:[20, 40, 60, 100],
    sortname: 'sort_index',
    sortorder: 'desc',
    viewrecords: true,
    gridview: true,
    caption: '用戶',
    resizable: true,
    height: "auto",
    #id: "_id"
    autowidth: true,

    }

  );

#  $(".remote_invoke").bind "click", (event) =>
#    link = $(event.currentTarget)
#    the_url = link.data("url")
#    $.ajax( {url: the_url, format: "js" })
