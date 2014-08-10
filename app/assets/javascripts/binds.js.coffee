InitPage = ->
  $("[rel='tooltip']").tooltip()
  $(".select2").select2
    placeholder: "Select one or more coins"

  $(".editable").editable
    success: (response, newValue) ->
      $.ajax
        url: $("#current").attr("data-url"),
        dataType: "script",
        data: { round: response.round }
      return

    error: (response, newValue) ->
      if response.status is 500
        "Service unavailable. Please try later."
      else
        response.responseText
      return



$(window).bind 'page:change', ->
  InitPage()

# $(document).ready ->
#   InitPage()
