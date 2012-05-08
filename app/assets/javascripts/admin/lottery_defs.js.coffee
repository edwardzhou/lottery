# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#lottery_list").jqGrid( {
      url: gon.page_json_url
      datatype: 'json',
      mtype: 'GET',
      colModel: [
        {name: '_id', index: '_id', label: "ID", width: 200},
        {name: 'lottery_name', index: 'lottery_name', label: "彩票", width: 200}
        {name: 'description', index: 'description', label: "描述", width: 200}
        {name: 'link', index: '', label: "操作", width: 200, sortable: false}
      ],
      jsonReader : {
        root:"rows",
        repeatitems: false,
        id: "_id"
      },
      pager: '#pager',
      rowNum: 20,
      rowList:[20,40,60],
      sortname: 'id',
      sortorder: 'asc',
      viewrecords: true,
      gridview: true,
      caption: '彩票',
      resizable: true,
      #id: "_id"
      #autowidth: true,

    }

  );