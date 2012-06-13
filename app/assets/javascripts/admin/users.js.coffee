# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

getFilters = () ->
  filters = {}
  roles = []
  $(".user_role").filter("[checked]").each (index) ->
    roles.push($(this).val())
  if roles.length > 0
    filters["user_role[]"] = roles.join(",")

  search_text = $(".search_text")
  if search_text.val().trim().length > 0
    filters[search_text.data("filter")] = search_text.val().trim()
  else
    filters[search_text.data("filter")] = ""
  #filters["filter"] = "周"
  return filters

doUserSearch = (this_obj) ->
  $("#user_list").jqGrid("setGridParam", {postData: getFilters()}).trigger("reloadGrid")

jQuery ->
  if $("#user_list").size() > 0
    $("#user_list").jqGrid( {
      url: gon.page_json_url
      datatype: 'json',
      mtype: 'GET',
      colModel: [
        {name: 'username', index: 'username', label: "用戶名", width: 100}
        {name: 'true_name', index: 'true_name', label: "姓名", width: 100}
        {name: 'phone', index: 'true_name', label: "電話", width: 100}
        {name: 'user_role', index: 'user_role', label: "身份", width: 60}
        {name: 'user_agent', index: 'agent_id', label: "所屬代理", width: 60}
        {name: 'user_top_user', index: 'top_user_id', label: "所屬一級", width: 60}
        {name: 'odds_level_name', index: 'odds_level_name', label: "盤級", width: 40}
        {name: 'total_credit', index: 'total_credit', label: "信用額度", width: 100, formatter: "number", formatoptions: {thousandsSeparator: ","} }
        {name: 'available_credit', index: 'available_credit', label: "可用額度", width: 100, formatter: "number", formatoptions: {thousandsSeparator: ","} }
        {name: 'locked', index: 'locked', label: "狀態", width: 60}
        {name: 'locked_at', index: 'locked_at', label: "鎖定時間", width: 130, formatter: "date", formatoptions: {srcformat: 'Y-m-d H:i:s',newformat : 'Y-m-d H:i:s'} }
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
      rowList:[20, 40, 60, 100],
      sortname: 'username',
      sortorder: 'asc',
      viewrecords: true,
      gridview: true,
      caption: '用戶',
      resizable: true,
      height: "auto",
      width: 900
      #id: "_id"
      #autowidth: true,

      }

    );


  if $("#new_user_form").size() > 0
    alert("new user form");
    $("#new_user_form").validate();
    $("#user_password_confirmation").rules("add", {equalTo: "#user_password" })

  if $("#search_button").size() > 0
    $("#search_button").bind "click" , ->
      doUserSearch(this)




