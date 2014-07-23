window.processing = false

window.create_alert = (response, style) ->
  if window.processing
    return false
  if typeof(response) == "string"
    response = { message: response }
  if not response.header
    response.header = "We have a problem here."

  style = style || "danger";

  window.processing = true
  alert_window = '<div id="handy-alert"><div class="alert alert-'+style+'"><a class="close" data-dismiss="alert">×</a><h4 class="alert-heading">' \ 
                 +response.header+'</h4><p>'+response.message+'</p></div></div>'
  if $('#handy-alert').length
    $('#handy-alert').replaceWith(alert_window)
    $('#handy-alert').effect("shake", {times: 2}, 1000, ->
      window.processing = false
    )
  else
    $('.content').prepend(alert_window)
    $('#handy-alert').css('display', 'none').slideDown('normal')
    window.processing = false

window.blink_title = (new_title) ->
  window.old_title = window.old_title || document.title

  if window.blinker
    clearInterval(blinker)
    clearTimeout(window.await_for)

  window.blinker = setInterval ->
    if document.title != new_title
      document.title = new_title
    else
      document.title = "[!] " + new_title
  , 1000

  window.await_for = setTimeout ->
    clearInterval(window.blinker)
    document.title = window.old_title
  , 7000

  $(window).one 'mousemove', ->
    clearInterval(window.blinker)
    document.title = window.old_title
    clearTimeout(window.await_for)

window.create_notify = (message) ->
  center = $('.notification-center')
  if message.id
    data_id = ' data-id="'+message.id+'"'
  else
    data_id = ''

  li = $('li[data-id="'+message.id+'"]')
  if li.length
    li.effect("highlight", {}, 1500)
  else
    time_str = "["+current_time()+"] "
    center.find('ul').append('<li'+data_id+'>'+time_str+message.body+"</li>")

  center.slideDown('slow')
  if message.header
    window.blink_title message.header

link_to_user = (username, platform) ->
  return '<a href="'+platform+'/players/'+username+'">'+username+'</a>'


init_ajax_loader = (elem) ->
  if elem.data("processing") || elem.hasClass('active')
    return false
  elem.find(".fa-refresh").addClass("fa-spin")

  # orig_text = elem.text()
  # i = 1
  # $.doTimeout 300, ->
  #   if i > 3
  #     elem.text(orig_text)
  #     i = 1
  #   else
  #     elem.text(elem.text() + '.')
  #     i += 1

  #   if elem.data("processing")
  #     return true
  #   else
  #     elem.text(orig_text)
  #     return false

current_time = -> 
  time = new Date;
  hours = time.getHours()
  minutes = time.getMinutes()
  seconds = time.getSeconds()
  if parseInt(hours) < 10
    hours = "0"+hours
  if parseInt(minutes) < 10
    minutes = "0"+minutes
  if parseInt(seconds) < 10
    seconds = "0"+seconds
  return hours+':'+minutes+':'+seconds


$(document).ready ->

  $("#recaptcha_image").on "click", ->
    Recaptcha.reload()


  $(document).on "ajax:beforeSend", "a[data-remote]", ->
    if $(this).data("processing") or $(this).attr('disabled')
      return false
    else
      init_ajax_loader $(this)
      $(this).data("processing", true).attr("disabled", "disabled")


  $(document).on "ajax:complete", "a[data-remote]", ->
    $(this).removeData("processing").removeAttr("disabled").find('.fa-refresh').removeClass('fa-spin')


  $(document).on "ajax:error", "a[data-remote], form[data-remote]", (data, response) ->
    if response.status == 403
       response = JSON.parse(response.responseText)
       window.create_alert(response)