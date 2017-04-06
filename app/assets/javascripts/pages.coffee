# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('#countdown').countdown {until: new Date(2017, 5, 21), layout: '{dn} {dl}, {hn} {hl}, {mn} {ml}, {sn} {sl}'}
  options = {
    useEasing : true,
    useGrouping : true,
    separator : ',',
    decimal : '.',
    prefix : '',
    suffix : ''
  }
  firstPlace = new countUp "FirstPlace", 0, 43, 0, 2.5, options
  topThree = new countUp "TopThree", 0, 141, 0, 2.5, options
  topTen = new countUp "TopTen", 0, 290, 0, 2.5, options

  isElementInViewport = (el) ->
    rect = el[0].getBoundingClientRect()
    rect.bottom < 900

  onVisibilityChange = (callback) ->
    console.log("Called")
    visible = isElementInViewport($("#awardSection"))
    if visible
      callback()
    return

  $(window).on 'DOMContentLoaded load resize scroll', ->
    onVisibilityChange (->
      firstPlace.start()
      topThree.start()
      topTen.start()
    )
