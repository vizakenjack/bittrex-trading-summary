InitPage = ->
  $("[rel='tooltip']").tooltip()
  $(".select2").select2(
    placeholder: "Select one or more coins"
  )

$(window).bind 'page:change', ->
  InitPage()

# $(document).ready ->
#   InitPage()
