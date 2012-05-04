# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

load_odds(data) ->


jQuery ->
  $.ajax({url: "#{gaming_path('ball7')}"}).done( function(data) {load_odds(data)} );
