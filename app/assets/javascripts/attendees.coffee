# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
redirect = () ->
  window.location.replace '/attendee'

String::capitalizeFirstLetter = () ->
  return this.charAt(0).toUpperCase() + this.slice(1);

$(document).on 'turbolinks:load', ->
  $('#attendee_search').keyup ->
    text = $(this).val()
    re =  RegExp(text ,"i");
    $(".member_name").filter ->
      if re.test($(this).html())
        $(this).parent().fadeIn("fast")
      else
        $(this).parent().fadeOut("fast")
  $('#new_attendee').on 'ajax:send', ->
    $(this).children('fieldset').attr 'class', 'form-group'
    $(this).children('fieldset').children('div').remove()
  $('#new_attendee').on 'ajax:success', ->
    $("#checked_in").children('tbody').append("<tr><td>" + $(this).parent().parent().children('.member_name')[0].innerText + "</td></tr>")
    $(this).parent().parent().fadeOut("fast")
  $('#new_attendee').on 'ajax:error', (evt, xhr, status, error) ->
    $('input').attr('disabled', false)
    errors = xhr.responseJSON.error if xhr.responseJSON?
    if !xhr.responseJSON?
      alert 'An error has occured, are you connected to the internet?'
      return
    for form of errors
      fieldSet = $(this).find("#attendee_#{form}").parent()
      fieldSet.addClass 'form-group has-danger'
      for key of errors[form]
        error = form.capitalizeFirstLetter().replace(/_/g, ' ') + ' ' + errors[form][key]
        fieldSet.append("<div><small class=\"text-danger\">#{error}</small></div>")
