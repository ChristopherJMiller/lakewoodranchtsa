redirect = () ->
  window.location.replace window.location.href

String::capitalizeFirstLetter = () ->
  return this.charAt(0).toUpperCase() + this.slice(1);

$(document).on 'turbolinks:load', ->
  $('a[name="navbar_logout"]').parent().on 'ajax:success', ->
    setTimeout redirect, 250
  $('a[name="navbar_logout"]').parent().on 'ajax:error', ->
    alert 'An error has occured, are you connected to the internet?'

  $('#navbar_login').on 'ajax:send', ->
    $(this).children('fieldset').attr 'class', 'form-group'
    $(this).children('fieldset').children('div').remove()
  $('#navbar_login').on 'ajax:success', ->
    $(this).children('fieldset').addClass 'form-group has-success'
    setTimeout redirect, 1000
  $('#navbar_login').on 'ajax:error', (evt, xhr, status, error) ->
    errors = xhr.responseJSON.error if xhr.responseJSON?
    if !xhr.responseJSON?
      alert 'An error has occured, are you connected to the internet?'
      return
    for form of errors
      fieldSet = $(this).find("##{form}").parent()
      fieldSet.addClass 'form-group has-danger'
      for key of errors[form]
        error = errors[form][key]
        fieldSet.append("<div><small class=\"text-danger\">#{error}</small></div>")
