# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
redirect = () ->
  window.location.replace '/events'

String::capitalizeFirstLetter = () ->
  return this.charAt(0).toUpperCase() + this.slice(1);

$(document).on 'turbolinks:load', ->
  $('form[data-remote]').on 'ajax:send', ->
    $(this).children('fieldset').attr 'class', 'form-group'
    $(this).children('fieldset').children('div').remove()
    $('input').attr('disabled', true)
  $('form[data-remote]').on 'ajax:success', ->
    $(this).children('fieldset').addClass 'form-group has-success'
    if $(this).hasClass('edit_team')
      setTimeout (window.location.href = window.location.href), 2000
    else if $(this).hasClass('button_to')
      setTimeout (window.location.href = window.location.href), 0
    else
      setTimeout redirect, 1000
  $('form[data-remote]').on 'ajax:error', (evt, xhr, status, error) ->
    $('input').attr('disabled', false)
    errors = xhr.responseJSON.error if xhr.responseJSON?
    if !xhr.responseJSON?
      alert 'An error has occured, are you connected to the internet?'
      return
    for form of errors
      fieldSet = $(this).find("#team_#{form}").parent()
      fieldSet.addClass 'form-group has-danger'
      for key of errors[form]
        error = form.capitalizeFirstLetter().replace(/_/g, ' ') + ' ' + errors[form][key]
        fieldSet.append("<div><small class=\"text-danger\">#{error}</small></div>")
