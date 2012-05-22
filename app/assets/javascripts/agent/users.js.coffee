# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

update_odds_level_info = (info)->
  alert(info)

jQuery ->
  $("#new_user_form").validate();

  $(".odds_level").bind "change", (event) =>
    select_box = $(event.currentTarget)
    form = $(event.currentTarget.form)
    odds_level_id = select_box.val();
    if odds_level_id.length > 0
      $.getScript( {url: gon.ol_page_url, data: { id: odds_level_id }
      } )
