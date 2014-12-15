@health_loaded = () ->
  reset_ui()

  $("#health-button").addClass("selected")
  uid = $("#shown-user-id")[0].value
  console.log "getting health data for user:"+uid
  actions_url = "/users/" + uid + "/measurements.json"
  d3.json(actions_url, draw_charts)

draw_charts = (data) ->
  health_type1 = "heartrate"
  health_type2 = "bloodpressure"
  health_type3 = "spo2"
  heart_trend_chart = new TrendChart("withings", "heart-trend", data,
    ["systolicbp", "pulse", "diastolicbp"],
    ["DIA", "HR", "SYS"],
    ["left", "right", "left"]
    )
  bp_chart = new HealthChart("withings", health_type1, health_type2, health_type3, data)
  now = new Date(Date.now())
  bp_chart.draw(now)
