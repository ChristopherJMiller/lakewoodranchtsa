# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
redirect = () ->
  window.location.replace '/announcements'

String::capitalizeFirstLetter = () ->
  return this.charAt(0).toUpperCase() + this.slice(1);

$(document).on 'turbolinks:load', ->
  $("#announcement_title").keyup ->
    $("#preview_title").html($("#announcement_title").val())
  $("#announcement_body").keyup ->
    $("#preview_body").html(markdown.toHTML($("#announcement_body").val()))
  $('#new_announcement').on 'ajax:send', ->
    $(this).children('fieldset').attr 'class', 'form-group'
    $(this).children('fieldset').children('div').remove()
    $('input').attr('disabled', true)
  $('#new_announcement').on 'ajax:success', ->
    $(this).children('fieldset').addClass 'form-group has-success'
    if $(this).hasClass('edit_event')
      setTimeout (window.location.href = window.location.href), 2000
    else
      setTimeout redirect, 2000
  $('#new_announcement').on 'ajax:error', (evt, xhr, status, error) ->
    $('input').attr('disabled', false)
    errors = xhr.responseJSON.error if xhr.responseJSON?
    if !xhr.responseJSON?
      alert 'An error has occured, are you connected to the internet?'
      return
    for form of errors
      fieldSet = $(this).find("#announcement_#{form}").parent()
      fieldSet.addClass 'form-group has-danger'
      for key of errors[form]
        error = form.capitalizeFirstLetter().replace(/_/g, ' ') + ' ' + errors[form][key]
        fieldSet.append("<div><small class=\"text-danger\">#{error}</small></div>")
