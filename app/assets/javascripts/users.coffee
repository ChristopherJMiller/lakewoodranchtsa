# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
redirect = () ->
  window.location.replace '/'

String::capitalizeFirstLetter = () ->
  return this.charAt(0).toUpperCase() + this.slice(1);

$(document).on 'turbolinks:load', ->
  $('[name="user[rank]"]').change ->
    $(this).parent().submit()
  $('#user_search').keyup ->
    text = $(this).val()
    re =  RegExp(text ,"i");
    $(".user_name").filter ->
      if re.test($(this).html())
        $(this).parent().fadeIn("fast")
      else
        $(this).parent().fadeOut("fast")
  $('#new_user').on 'ajax:send', ->
    $(this).children('fieldset').attr 'class', 'form-group'
    $(this).children('fieldset').children('div').remove()
    $( "input[name='commit']" ).prop("disabled",true);
  $('#new_user').on 'ajax:success', ->
    $(this).children('fieldset').addClass 'form-group has-success'
    if $(this).hasClass('edit_user')
      setTimeout (window.location.href = window.location.href), 2000
    else
      setTimeout redirect, 2000
  $('#new_user').on 'ajax:error', (evt, xhr, status, error) ->
    $( "input[name='commit']" ).prop("disabled",false);
    errors = xhr.responseJSON.error if xhr.responseJSON?
    if !xhr.responseJSON?
      alert 'An error has occured, are you connected to the internet?'
      return
    for form of errors
      fieldSet = $(this).find("#user_#{form}").parent()
      fieldSet.addClass 'form-group has-danger'
      for key of errors[form]
        error = form.capitalizeFirstLetter().replace(/_/g, ' ') + ' ' + errors[form][key]
        fieldSet.append("<div><small class=\"text-danger\">#{error}</small></div>")
