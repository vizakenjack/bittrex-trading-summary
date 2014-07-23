InitPage = ->
  $("[rel='tooltip']").tooltip()

$(window).bind 'page:change', ->
  InitPage()

# $(document).ready ->
#   InitPage()
