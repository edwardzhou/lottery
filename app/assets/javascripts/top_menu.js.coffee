jQuery ->
  $(".top_menu_button").bind "mouseover", (event) =>
    btn = $(event.currentTarget)
    btn.addClass(btn.data("hover"))
    btn.removeClass(btn.data("normal"))


  $(".top_menu_button").bind "mouseout", (event) =>
    btn = $(event.currentTarget)
    btn.addClass(btn.data("normal"))
    btn.removeClass(btn.data("hover"))

  $(".top_menu_button").bind "click",  (event) =>
    btn = $(event.currentTarget)
    window.location.href = btn.data("url")
