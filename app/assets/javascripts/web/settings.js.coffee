@settings_loaded = () ->
  reset_ui()
  define_globals()
  $("#settings-button").addClass("selected")

  $("#myprofile-link").click (event) ->
    event.preventDefault()
    reset_settings_ui()
    $("#myprofile-link").addClass("menulink-selected")
    $("#sectionProfile").removeClass("hiddenSection")

  $("#moves-link").click (event) ->
    event.preventDefault()
    reset_settings_ui()
    $("#moves-link").addClass("menulink-selected")
    $("#sectionMoves").removeClass("hiddenSection")

  $("#googlefit-link").click (event) ->
    event.preventDefault()
    reset_settings_ui()
    $("#googlefit-link").addClass("menulink-selected")
    $("#sectionGooglefit").removeClass("hiddenSection")

  $("#misfit-link").click (event) ->
    event.preventDefault()
    reset_settings_ui()
    $("#misfit-link").addClass("menulink-selected")
    $("#sectionMisfit").removeClass("hiddenSection")

  $("#fitbit-link").click (event) ->
    event.preventDefault()
    reset_settings_ui()
    $("#fitbit-link").addClass("menulink-selected")
    $("#sectionFitbit").removeClass("hiddenSection")

  $("#withings-link").click (event) ->
    event.preventDefault()
    reset_settings_ui()
    $("#withings-link").addClass("menulink-selected")
    $("#sectionWithings").removeClass("hiddenSection")

  $("#signin-moves-button").click (event) ->
    event.preventDefault()
    window.location = '/auth/moves'

  $("#disconnect-moves-button").click (event) ->
    event.preventDefault()
    window.location = '/pages/mdestroy'

  $("#signin-withings-button").click (event) ->
    event.preventDefault()
    window.location = '/auth/withings'

  $("#disconnect-withings-button").click (event) ->
    event.preventDefault()
    window.location = '/pages/wdestroy'

  $("#signin-misfit-button").click (event) ->
    event.preventDefault()
    window.location = '/auth/shine'

  $("#disconnect-misfit-button").click (event) ->
    event.preventDefault()
    window.location = '/sync/misfit_destroy'

  $("#signin-fitbit-button").click (event) ->
    event.preventDefault()
    window.location = '/auth/fitbit'

  $("#disconnect-fitbit-button").click (event) ->
    event.preventDefault()
    window.location = '/pages/fdestroy'

  $("#signin-google-button").click (event) ->
    event.preventDefault()
    window.location = '/auth/google_oauth2'

  $("#disconnect-google-button").click (event) ->
    event.preventDefault()
    window.location = '/pages/gfdestroy'

  $("#sync-moves-button").click (event) ->
    failure_message = "Sync failed <i class='fa fa-warning' style='color: red'></i>"
    $("#moves-sync-status").html("Syncing... <i class='fa fa-spinner fa-spin'></i>")
    $('body').addClass('wait');
    $.ajax "/sync/sync_moves",
      type: "GET"
      dataType: "json"
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "AJAX Error: #{textStatus}"
        $("#moves-sync-status").html(failure_message)
        $('body').removeClass('wait');
      success: (result, textStatus, jqXHR) ->
        console.log "Successful AJAX call"
        console.log result
        if result['status'] == "OK"
          $("#moves-sync-status").html("Synced just now <i class='fa fa-check' style='color: green'></i>")
        else
          $("#moves-sync-status").html(failure_message)
        $('body').removeClass('wait');

  $("#sync-withings-button").click (event) ->
    $("#withings-sync-status").html("Syncing... <i class='fa fa-spinner fa-spin'></i>")
    failure_message = "Sync failed <i class='fa fa-warning' style='color: red'></i>"
    $('body').addClass('wait');
    $.ajax "/sync/sync_withings",
      type: "GET"
      dataType: "json"
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "AJAX Error: #{textStatus}"
        $("#withings-sync-status").html(failure_message)
        $('body').removeClass('wait');
      success: (result, textStatus, jqXHR) ->
        console.log "Successful AJAX call"
        console.log result
        if result['status'] == "OK"
          $("#withings-sync-status").html("Synced just now <i class='fa fa-check' style='color: green'></i>")
          console.log result['data']
        else
          $("#withings-sync-status").html(failure_message)
        $('body').removeClass('wait');

  $("#sync-misfit-button").click (event) ->
    $("#misfit-sync-status").html("Syncing... <i class='fa fa-spinner fa-spin'></i>")
    failure_message = "Sync failed <i class='fa fa-warning' style='color: red'></i>"
    $('body').addClass('wait');
    $.ajax "/sync/sync_misfit",
      type: "GET"
      dataType: "json"
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "AJAX Error: #{textStatus}"
        $("#misfit-sync-status").html(failure_message)
        $('body').removeClass('wait');
      success: (result, textStatus, jqXHR) ->
        console.log "Successful AJAX call"
        console.log result
        if result['status'] == "OK"
          $("#misfit-sync-status").html("Synced just now <i class='fa fa-check' style='color: green'></i>")
          console.log result['data']
        else
          $("#misfit-sync-status").html(failure_message)
        $('body').removeClass('wait');

  $("#sync-fitbit-button").click (event) ->
    $("#fitbit-sync-status").html("Syncing... <i class='fa fa-spinner fa-spin'></i>")
    failure_message = "Sync failed <i class='fa fa-warning' style='color: red'></i>"
    $('body').addClass('wait');
    $.ajax "/sync/sync_fitbit",
      type: "GET"
      dataType: "json"
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "AJAX Error: #{textStatus}"
        $("#fitbit-sync-status").html(failure_message)
        $('body').removeClass('wait');
      success: (result, textStatus, jqXHR) ->
        console.log "Successful AJAX call"
        console.log result
        if result['status'] == "OK"
          $("#fitbit-sync-status").html("Synced just now <i class='fa fa-check' style='color: green'></i>")
          console.log result['data']
        else
          $("#fitbit-sync-status").html(failure_message)
        $('body').removeClass('wait');

  $("#sync-google-button").click (event) ->
    $("#google-sync-status").html("Syncing... <i class='fa fa-spinner fa-spin'></i>")
    failure_message = "Sync failed <i class='fa fa-warning' style='color: red'></i>"
    $('body').addClass('wait');
    $.ajax "/sync/sync_google",
      type: "GET"
      dataType: "json"
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "AJAX Error: #{textStatus}"
        $("#google-sync-status").html(failure_message)
        $('body').removeClass('wait');
      success: (result, textStatus, jqXHR) ->
        console.log "Successful AJAX call"
        console.log result
        if result['status'] == "OK"
          $("#google-sync-status").html("Synced just now <i class='fa fa-check' style='color: green'></i>")
          console.log result['data']
        else
          $("#google-sync-status").html(failure_message)
        $('body').removeClass('wait');

  popup_messages = JSON.parse($("#popup-messages").val())

  $('#profile_birth_datepicker').datetimepicker({
    format: 'Y-m-d',
    timepicker: false,
    onSelectDate: (ct, input) ->
      input.datetimepicker('hide')
    todayButton: true,
    maxDate: '0',
    minDate: new Date(1900, 1 - 1, 1)
  })

  $("form.resource-update-form.user-form").on("ajax:success", (e, data, status, xhr) ->
    form_id = e.currentTarget.id
    $("#"+form_id+" input.dataFormField").val("")
    console.log status
    if JSON.parse(xhr.responseText).status == "NOK"
#      popup_error(popup_messages.failed_to_add_data)
      popup_error(JSON.parse(xhr.responseText).msg)
    else
      popup_success(popup_messages.save_success)
  ).on("ajax:error", (e, data, status, xhr) ->
#    popup_error(popup_messages.failed_to_add_data)
    popup_error(JSON.parse(xhr.responseText).msg)
  )

  $("form.resource-update-form.profile-form").on("ajax:success", (e, data, status, xhr) ->
    form_id = e.currentTarget.id
    $("#"+form_id+" input.dataFormField").val("")
    if JSON.parse(xhr.responseText).status == "NOK"
#      popup_error(popup_messages.failed_to_add_data)
      popup_error(JSON.parse(xhr.responseText).msg)
    else
      console.log "update profile clicked"
      #ha default lang changed
      if JSON.parse(xhr.responseText).default_lang_changed
        location.pathname = "/"+JSON.parse(xhr.responseText).locale+location.pathname.substr(3)
      popup_success(popup_messages.save_success)
#      location.reload()
  ).on("ajax:error", (e, data, status, xhr) ->
#    popup_error(popup_messages.failed_to_add_data)
    popup_error(JSON.parse(xhr.responseText).msg)
  )

@reset_settings_ui = () ->
  $(".menuitem a.menulink").removeClass("menulink-selected")
  $(".menu-section").addClass("hiddenSection")