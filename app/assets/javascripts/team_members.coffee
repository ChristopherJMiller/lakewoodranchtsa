# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
redirect = () ->
  window.location.replace './'

String::capitalizeFirstLetter = () ->
  return this.charAt(0).toUpperCase() + this.slice(1);

$(document).on 'turbolinks:load', ->
  $('#new_team_member').on 'ajax:send', ->
    $(this).children('fieldset').attr 'class', 'form-group'
    $(this).children('fieldset').children('div').remove()
    $('input').attr('disabled', true)
  $('#new_team_member').on 'ajax:success', ->
    if $(this).hasClass('new_team_member') || $(this).hasClass('button_to')
      setTimeout redirect, 0
    else
      setTimeout (window.location.href = window.location.href), 0
  $('#new_team_member').on 'ajax:error', (evt, xhr, status, error) ->
    $('input').attr('disabled', false)
    errors = xhr.responseJSON.error if xhr.responseJSON?
    if xhr.status == 409
      element = $(this).find("#team_member_user_id").parent()
      element.addClass 'form-group has-danger'
      element.append("<div><small class=\"text-danger\">This user is already part of this team</small></div>")
      return
    else if !xhr.responseJSON?
      alert 'An error has occured, are you connected to the internet?'
      return
    for form of errors
      fieldSet = $(this).find("#team_member_#{form}").parent()
      fieldSet.addClass 'form-group has-danger'
      for key of errors[form]
        error = form.capitalizeFirstLetter().replace(/_/g, ' ') + ' ' + errors[form][key]
        fieldSet.append("<div><small class=\"text-danger\">#{error}</small></div>")
