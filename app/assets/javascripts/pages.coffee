# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('#countdown').countdown {until: new Date(2017, 2, 1), layout: '{dn} {dl}, {hn} {hl}, {mn} {ml}, {sn} {sl}'}
  options = {
    useEasing : true,
    useGrouping : true,
    separator : ',',
    decimal : '.',
    prefix : '',
    suffix : ''
  }
  statAwards = new CountUp "statesAwards", 0, 100, 0, 2.5, options
  statAwards.start
