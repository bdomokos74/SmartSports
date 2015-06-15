
class RRChart
  constructor: (@chart_element, rrdata, hrdata, crdata, speed_data) ->
    @base_r = 6
    @selected_r = 9
    @lines = []
    @charts = []
    @svg = []
    @data = []
    @y_extent= []
    @y_scale = []
    @axisText = []
    @n = 0

    axisAll = ['ms', '1/min', 'r/min', 'km/h']
    if rrdata
      @data.push(rrdata)
      @axisText[@n] = axisAll[0]
      @n+=1
    if hrdata
      @data.push(hrdata)
      @axisText[@n] = axisAll[1]
      @n+=1
    if crdata
      @data.push(crdata)
      @axisText[@n] = axisAll[2]
      @n+=1
    if speed_data
      @axisText[@n] = axisAll[3]
      @n+=1
      @data.push(speed_data)

    this.clear()

  draw: () ->
    self = this

    chart_aspect = 1.3
    @margin = {top: 20, right: 30, bottom: 20, left: 40}
    @aspect = chart_aspect*@n/7.0

    @width = $("#"+@chart_element+"-container").width()
    @height = @aspect*@width
    @chart_height = chart_aspect/7.0*@width

    @svg = d3.select($("#"+@chart_element+"-container svg."+@chart_element+"-chart-svg")[0])
    @svg
      .attr("width", self.width)
      .attr("height", self.height)

    for i in [0..@n-1]
      ch = @svg
        .append("g")
        .attr("transform", "translate(0,"+(1.0*i*self.chart_height)+")")
      @charts.push(ch)

      sum_fn = (s, a) ->
        s+a.value
      avg = @data[i].reduce( sum_fn , 0)/@data[i].length

      @data[i] = @data[i].filter( (x) ->
        x.value<2*avg
      )
      console.log "avg="+avg.toFixed(2)

      y_extent = d3.extent(@data[i], (d) -> d.value)
      @y_extent.push(y_extent)
      y_scale = d3.scale.linear().range([self.chart_height - self.margin.bottom- self.margin.top, 0]).domain(@y_extent[i])
      @y_scale.push(y_scale)


    time_extent = d3.extent(@data[0], (d) -> new Date(d.time))
    @time_scale = d3.time.scale().domain(time_extent).range([0, self.width-self.margin.left-self.margin.right])
    @time_axis = d3.svg.axis()
      .scale(@time_scale)
      .ticks(10)

    for i in [0..(@n-1)]
      z = self.draw_plot(i)
      @lines.push(z)

    zoom = d3.behavior.zoom()
      .on("zoom", self.do_zoom)

    @svg.append("rect")
      .attr("class", "pane")
      .attr("width", self.width)
      .attr("height", self.height)
      .call(zoom)

    zoom.x(@time_scale)

  do_zoom: () =>
    self = this
    console.log "do_zoom"
    console.log self.lines
    @svg.select("g.x.axis").call(@time_axis)
    for j in [0..(self.n-1)]
      self.charts[j].select("path.line").attr("d", self.lines[j](self.data[j]))

  clear: () ->
    $("svg."+@chart_element+"-chart-svg").html("")

  draw_plot: (i) -> #chart, data, yAxisText="ms") ->
    self = this

    rrline = d3.svg.line()
      .x( (d) -> return(self.time_scale(new Date(d.time))))
      .y( (d) -> return(self.y_scale[i](d.value)))

    canvas = @charts[i]
      .append("g")
      .attr("transform", "translate("+self.margin.left+","+(self.margin.top)+")")

    @charts[i].append("g")
      .attr("class", "x axis")
      .attr("transform", "translate("+self.margin.left+","+(self.chart_height-self.margin.bottom)+")")
      .call(self.time_axis)

    y_axis = d3.svg.axis().scale(self.y_scale[i]).orient("left").ticks(7)
    @charts[i].append("g")
      .attr("class", "y axis")
      .attr("transform", "translate("+self.margin.left+","+self.margin.top+")")
      .attr("stroke-width", "0")
      .call(y_axis)
      .append("text")
      .text(@axisText[i])

    canvas.append("path")
      .attr("class", "line rr")
      .attr("d", rrline(self.data[i]))

    return(rrline)

tmp: () ->
    time_extent = d3.extent(@data, (d) -> new Date(d.date))
    time_scale = d3.time.scale().domain(time_extent).range([0, self.width-self.margin.left-self.margin.right])

    y_extent = d3.extent(@data, (d) -> d.systolicbp)
    y_extent[0] = 50
    y_extent[1] = Math.max(y_extent[1], 150)
    y_scale = d3.scale.linear().range([self.height - self.margin.bottom- self.margin.top, 0]).domain(y_extent)

    ldata = @create_lines(y_extent)
    canvas.selectAll("line")
    .data(ldata)
    .enter()
    .append("svg:line")
    .attr("x1", time_scale(time_extent[0]))
    .attr("y1", (d) -> y_scale(d.x))
    .attr("x2", time_scale(time_extent[1]))
    .attr("y2", (d) -> y_scale(d.x))
    .attr("stroke", (d) -> d.color)
    .attr("stroke-width", 1)
    .attr("opacity", 1)

    time_axis = d3.svg.axis()
    .scale(time_scale)
    .ticks(5)

    svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate("+self.margin.left+","+(self.height-self.margin.bottom)+")")
      .call(time_axis)

    y_axis = d3.svg.axis().scale(y_scale).orient("left")
    svg.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate("+self.margin.left+","+self.margin.top+")")
      .attr("stroke-width", "0")
      .call(y_axis)
      .append("text")
      .text("mmHg")


    @nodata = false
    if @data.length ==0
      @nodata = true

    if @nodata
      svg.append("text")
      .text("No data")
      .attr("class", "warn")
      .attr("x", self.width/2-self.margin.left)
      .attr("y", self.height/2)
      return

    svg.select(".x.axis")
      .append("text")
      .text("Date")
      .attr("x", (self.width / 2) - self.margin.left)
      .attr("y", self.margin.bottom+self.margin.top)


    hr_extent = d3.extent(@data, (d) -> d.pulse)
    hr_extent[0] = Math.min(hr_extent[0], 50)
    hr_extent[1] = Math.max(hr_extent[1], 200)
    hr_range = hr_extent[1]-hr_extent[0]

    classfn = (d) -> "colset9_"+Math.round(1.0*(d.pulse-hr_extent[0])/hr_range*7.0).toString()

    canvas.selectAll("circle.sys")
    .data(@data)
    .enter()
    .append("circle")
    .attr("cx", (d) -> time_scale(new Date(d.date)))
    .attr("cy", (d) -> y_scale(d.systolicbp))
    .attr("r", @base_r)
    .attr("class", (d) -> "sys "+classfn(d))
    .attr("id", (d) -> "sys-"+d.data_id.toString())
    .on("mouseover", (d) ->
      if d.systolicbp
        $("#"+self.chart_element+"-container").find("div.selected-meas").html(d.systolicbp.toString()+"/"+d.diastolicbp.toString()+" "+d.pulse.toString())
      d3.select(this)
      .transition()
      .attr("r", self.selected_r)
      d3.select(this).classed("selected", true)
      id = this.id.toString().substr(4)
      d3.select("circle#dia-"+id)
      .transition()
      .attr("r", self.selected_r)
      d3.select("circle#dia-"+id).classed("selected", true)
      d3.select("line#press-"+id)
      .transition()
      .style("stroke-width", 4)
      d3.select("line#press-"+id).classed("selected", true)
    )
    .on("mouseout", (d) ->
      $("#"+self.chart_element+"-container").find("div.selected-meas").html("")
      d3.select(this)
      .transition()
      .attr("r", self.base_r)
      d3.select(this).classed("selected", false)
      id = this.id.toString().substr(4)
      d3.select("circle#dia-"+id)
      .transition()
      .attr("r", self.base_r)
      d3.select("circle#dia-"+id).classed("selected", false)
      d3.select("line#press-"+id)
      .transition()
      .style("stroke-width", 2)
      d3.select("line#press-"+id).classed("selected", false)
    )

    canvas.selectAll("circle.dia")
    .data(@data)
    .enter()
    .append("circle")
    .attr("cx", (d) -> time_scale(new Date(d.date)))
    .attr("cy", (d) -> y_scale(d.diastolicbp))
    .attr("r", self.base_r)
    .attr("class", (d) -> "dia "+classfn(d))
    .attr("id", (d) -> "dia-"+d.data_id.toString())
    .on("mouseover", (d) ->
      if d.systolicbp
        $("#"+self.chart_element+"-container").find("div.selected-meas").html(d.systolicbp.toString()+"/"+d.diastolicbp.toString()+" "+d.pulse.toString())
      d3.select(this)
      .transition()
      .attr("r", self.selected_r)
      d3.select(this).classed("selected", true)
      id = this.id.toString().substr(4)
      d3.select("circle#sys-"+id)
      .transition()
      .attr("r", self.selected_r)
      d3.select("circle#sys-"+id).classed("selected", true)
      d3.select("line#press-"+id)
      .transition()
      .style("stroke-width", 4)
      d3.select("line#press-"+id).classed("selected", true)
    )
    .on("mouseout", (d) ->
      $("#"+self.chart_element+"-container").find("div.selected-meas").html("")
      d3.select(this)
      .transition()
      .attr("r", self.base_r)
      d3.select(this).classed("selected", false)
      id = this.id.toString().substr(4)
      d3.select("circle#sys-"+id)
      .transition()
      .attr("r", self.base_r)
      d3.select("circle#sys-"+id).classed("selected", false)
      d3.select("line#press-"+id)
      .transition()
      .style("stroke-width", 2)
      d3.select("line#press-"+id).classed("selected", false)
    )

    canvas.selectAll("line.press")
    .data(@data)
    .enter()
    .append("line")
    .attr("x1", (d) -> time_scale(new Date(d.date)))
    .attr("y1", (d) -> y_scale(d.diastolicbp))
    .attr("x2", (d) -> time_scale(new Date(d.date)))
    .attr("y2", (d) -> y_scale(d.systolicbp))
    .attr("stroke-width", 2)
    .attr("class", (d) -> "press "+classfn(d))
    .attr("id", (d) -> "press-"+d.data_id.toString())



  create_lines:  (r) ->
    start = r[0] - r[0] % 5
    end = r[1] - r[1] % 5
    i = start
    ret = []
    while i <= end
      col = '#e0e0e0'
      if i % 25 == 0
        col = '#c0c0c0'
      ret.push({x: i, color: col})
      i += 5
    return ret

window.RRChart = RRChart
