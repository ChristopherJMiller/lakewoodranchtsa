# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
redirect = () ->
  window.location.replace '/'

String::capitalizeFirstLetter = () ->
  return this.charAt(0).toUpperCase() + this.slice(1);

$(document).on 'turbolinks:load', ->
  $('form[data-remote]').on 'ajax:send', ->
    $(this).children('fieldset').attr 'class', 'form-group'
    $(this).children('fieldset').children('div').remove()
    $('input').attr('disabled', true)
  $('form[data-remote]').on 'ajax:success', ->
    $(this).children('fieldset').addClass 'form-group has-success'
    setTimeout redirect, 1000
  $('form[data-remote]').on 'ajax:error', (evt, xhr, status, error) ->
    $('input').attr('disabled', false)
    errors = xhr.responseJSON.error
    for form of errors
      fieldSet = $(this).find("#session_#{form}").parent()
      fieldSet.addClass 'form-group has-danger'
      for key of errors[form]
        error = form.capitalizeFirstLetter().replace(/_/g, ' ') + ' ' + errors[form][key]
        fieldSet.append("<div><small class=\"text-danger\">#{error}</small></div>")
