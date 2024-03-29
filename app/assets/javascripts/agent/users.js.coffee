# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



getFilters = () ->
  filters = {}
  roles = []
  if roles.length > 0
    filters["user_role"] = roles.join(",")
  else
    filters["user_role"] = ""

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
        {name: 'username', index: 'username', label: "用户名", width: 100}
        {name: 'true_name', index: 'true_name', label: "姓名", width: 100}
        {name: 'phone', index: 'true_name', label: "电话", width: 100}
        {name: 'user_role', index: 'user_role', label: "身份", width: 60}
        {name: 'odds_level_name', index: 'odds_level_name', label: "盘级", width: 40}
        {name: 'total_credit', index: 'total_credit', label: "信用额度", width: 100}
        {name: 'available_credit', index: 'available_credit', label: "可用额度", width: 100}
        {name: 'locked', index: 'locked', label: "状态", width: 100}
        {name: 'locked_at', index: 'locked_at', label: "锁定时间", width: 130, formatter: "date", formatoptions: {srcformat: 'Y-m-d H:i:s',newformat : 'Y-m-d H:i:s'} }
        {name: 'show_url', index: '', label: " ", width: 60, sortable: false}
        {name: 'edit_url', index: '', label: " ", width: 60, sortable: false}
        {name: 'lock_account_url', index: '', label: " ", width: 60, sortable: false}
        {name: 'reset_credit_url', index: '', label: " ", width: 60, sortable: false}
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
      height: 350,
      #id: "_id"
      #autowidth: true,

      }

    );

  if $("#new_user_form").size() > 0
    $("#new_user_form").validate();
    $("#user_password_confirmation").rules("add", {equalTo: "#user_password" }) if $("#user_password_confirmation").size() > 0


  $(".odds_level").bind "change", (event) =>
    select_box = $(event.currentTarget)
    form = $(event.currentTarget.form)
    odds_level_id = select_box.val();
    the_url = gon.ol_page_url + "/" + odds_level_id
    if odds_level_id.length > 0
      $.ajax( {url: the_url, format: "js" })

  if $("#search_button").size() > 0
    $("#search_button").bind "click" , ->
      doUserSearch(this)


