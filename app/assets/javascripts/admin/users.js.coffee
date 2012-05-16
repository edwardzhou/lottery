# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#user_list").jqGrid( {
    url: gon.page_json_url
    datatype: 'json',
    mtype: 'GET',
    colModel: [
      {name: 'username', index: 'username', label: "用户名", width: 100}
      {name: 'true_name', index: 'true_name', label: "姓名", width: 100}
      {name: 'phone', index: 'true_name', label: "电话", width: 100}
      {name: 'total_credit', index: 'total_credit', label: "信用额度", width: 100}
      {name: 'available_credit', index: 'available_credit', label: "可用额度", width: 100}
      {name: 'locked', index: 'locked', label: "状态", width: 100}
      {name: 'locked_at', index: 'locked_at', label: "锁定时间", width: 130, formatter: "date", formatoptions: {srcformat: 'Y-m-d H:i:s',newformat : 'Y-m-d H:i:s'} }
      {name: 'show_url', index: '', label: " ", width: 60, sortable: false}
      {name: 'edit_url', index: '', label: " ", width: 60, sortable: false}
      {name: 'lock_account_url', index: '', label: " ", width: 60, sortable: false}
    ],
    jsonReader : {
    root:"rows",
    repeatitems: false,
    id: "_id"
    },
    pager: '#pager',
    rowNum: 20,
    rowList:[20,40,60],
    sortname: 'username',
    sortorder: 'asc',
    viewrecords: true,
    gridview: true,
    caption: '用户',
    resizable: true,
    #id: "_id"
    #autowidth: true,

    }

  );