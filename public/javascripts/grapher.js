  w = 800
  h = 500
  padding = 35

  var addTitle = function(svg) {
    svg.append('text').text("Number of machines")
        .attr("x", 40)
        .attr("y", 40)
        .attr("font-family", "sans-serif")
        .attr("class", "graphtitle")
        .attr("font-size", "18px")
        .attr("fill", 'black');
    svg.append('text').text("over time")
        .attr("x", 40)
        .attr("y", 60)
        .attr("font-family", "sans-serif")
        .attr("class", "graphtitle")
        .attr("font-size", "18px")
        .attr("fill", 'black');
  }

  var getPathYForX = function(path, x) {
    // binary search for x
    var length = path.getTotalLength();
    if (isNaN(length)) {
      // this is a bug in Firefox, which combined with another FF bug
      // makes it impossible for us to do this calculation.
      // Just stick the label along the baseline
      return d3.scale.linear()
            .range([padding, h-padding])
            .domain([w-padding, padding])(x);
    }
    var lowerBound = 0;
    var upperBound = length
    var xError;
    var point;
    do {
      var lengthMaybe = lowerBound + (upperBound - lowerBound)/2;
      point = path.getPointAtLength(lengthMaybe);
      xError = x - point.x;
      if (xError > 0) {
        // need upper segment
        lowerBound = lengthMaybe;
      } else if (xError < 0) {
        // need lower segment
        upperBound = lengthMaybe;
      }
    } while(Math.abs(xError) >= 1 && lowerBound != upperBound)
    return point.y;
  }

  var scaleX = d3.time.scale()
            .range([padding, w-padding])
            .domain(d3.extent(machines_over_time, function(d){return new Date(d[0])}));
  var scaleY = d3.scale.linear()
            .range([padding, h-padding])
            .domain([
              d3.max(machines_over_time, function(d){return d[1]}),
              80
            ]);
  var svg = d3.select("body")
              .append("svg")
              .attr("width", w + 50)
              .attr("height", h);

  var line = d3.svg.line()
    .x(function(d) { return scaleX(new Date(d[0])) })
    .y(function(d) { return scaleY(d[1]) })
    .interpolate('cardinal');

  svg.append("path")
      .datum(machines_over_time)
      .attr("class", "line")
      .attr("stroke", "steelblue")
      .attr("d", line);

  var path = svg.select('path')[0][0];

  var timelineLabels = svg.selectAll("text").data(d3.entries(timeline)).enter()
    .append("text")
    .text(function(d){
      return d.value
    })
    .attr("x", function(d) {
      var date = +d.key*1000;
      var xpos = scaleX(new Date(date));
      d.anchorx = xpos;
      return xpos
    })
    .attr("y", function(d){
      var ypos = getPathYForX(path, d3.select(this).attr('x'));
      d.anchory = ypos;
      return ypos
    })
    .property("anchor", function(d){
      return {
        x:d.anchorx,
        y:d.anchory,
        r:35
      }
    })
    .attr("font-family", "sans-serif")
    .attr("font-size", "12px")
    .attr("stroke", "white")
    .attr("stroke-width", 3.0)
    .attr("paint-order", "stroke")
    .attr("fill", 'black');

  var links = svg.selectAll(".link")
      .data(timelineLabels[0])
      .enter()
      .append("line")
      .attr("class", "link")
      .attr("x1", function(d) {
        return +d3.select(d).attr('x')
      })
      .attr("y1", function(d) {
        return +d3.select(d).attr('y')
      })
      .attr("x2", function(d) {
        return +d3.select(d).attr('x')
      })
      .attr("y2", function(d) {
        return +d3.select(d).attr('y')
      })
      .attr("stroke-width", 0.6)
      .attr("stroke", "gray");

  d3.labeler()
    .label(timelineLabels)
    .start();

  timelineLabels
    .transition()
    .duration(0)
    .attr("x", function(d) { return this.alpx })
    .attr("y", function(d) { return this.alpy });

  links
    .transition()
    .duration(0)
    .attr("x2",function(d) { return d.alpx })
    .attr("y2",function(d) { return d.alpy });

  var xAxis = d3.svg.axis().scale(scaleX).orient("bottom");
  svg.append("g")
    .attr("class", "axis")
    .attr("transform", "translate(0," + (h - padding) + ")")
    .call(xAxis);

  var yAxis = d3.svg.axis()
                  .scale(scaleY)
                  .orient("left")
                  .ticks(20);

  svg.append("g")
      .attr("class", "axis")
      .attr("transform", "translate(" + padding + ",0)")
      .call(yAxis);

  addTitle(svg);

  if (isNaN(path.getTotalLength())) {
    svg.append('text')
      .text("* A bug in your browser is preventing us from labeling this chart properly. We did the best we could. Sorry :-(")
      .attr('x', padding + 10)
      .attr('y', padding + 50)
      .attr("font-family", "sans-serif")
      .attr("font-size", "8px")
      .attr("fill", 'black');
  }


// Individual title analysis
[titles_over_time, localities_over_time].forEach(function(data_over_time, index) {
  var TITLES = index == 0 ? true : false;
    
  var counts_for_scale = d3.values(data_over_time).map(function(time_series) {
    return d3.extent(time_series, function(time_count_pair){
      return time_count_pair[1]
    })
  }).reduce(function(a, b) {
    return a.concat(b);
  })
  var scaleY = d3.scale.linear()
            .range([padding, h-padding])
            .domain([d3.max(counts_for_scale), 0]);
  var svg = d3.select("body")
              .append("svg")
              .attr("width", w+500)
              .attr("height", h);

  var strokeStyles = ["none", "3 3", "8 2", "12 2 2 2", "1", "12 2 2 2 2 2"]
  var strokeIndex = 0;
  var arrayData = d3.entries(data_over_time).filter(function(el){
    if (!TITLES) {
      return true
    }
    // else we're filtering titles. Only return games that have had at least
    // N machines on location at some point
    return d3.max(
      el.value.map(function(point){
          return point[1]
        })
      ) > 7
  })

  var colorScale = d3.scale.category10();
  colorScale.domain(d3.keys(data_over_time));
  var colorFunc = function(d){
    return colorScale(d.key)
  };

  var line = d3.svg.line()
    .x(function(d) { 
      return scaleX(new Date(d[0])) 
    })
    .y(function(d) { 
      return scaleY(d[1]) 
    })
    .interpolate('cardinal');

  svg.selectAll("path").data(arrayData).enter()
    .append("path")
      .attr("class", "line")
      .attr("stroke", colorFunc)
      .style("stroke-dasharray", function(){
        return strokeStyles[strokeIndex++ % strokeStyles.length]
      })
      .datum(function(d){return d.value})
      .attr("d", line);
  svg.selectAll("text").data(arrayData).enter()
    .append("text")
      .text(function(d){
        return d.key
      })
      .attr("x", function(d) {
        var timeSeries = d.value;
        return scaleX(new Date(timeSeries[timeSeries.length-1][0])) + 5
      })
      .attr("y", function(d){
        var timeSeries = d.value;
        return scaleY(timeSeries[timeSeries.length-1][1]) + 10
      })
      .property("anchor", function(d){
        var timeSeries = d.value;
        return {
          x:scaleX(new Date(timeSeries[timeSeries.length-1][0])),
          y:scaleY(timeSeries[timeSeries.length-1][1]),
          r:7
        }
      })
      .attr("font-family", "sans-serif")
      .attr("class", "label" + index)
      .attr("font-size", "18px")
      .attr("fill", colorFunc);

  var xAxis = d3.svg.axis().scale(scaleX).orient("bottom");
  svg.append("g")
    .attr("class", "axis")
    .attr("transform", "translate(0," + (h - padding) + ")")
    .call(xAxis);
  var yAxis = d3.svg.axis()
                  .scale(scaleY)
                  .orient("left")
                  .ticks(10);

  svg.append("g")
      .attr("class", "axis")
      .attr("transform", "translate(" + padding + ",0)")
      .call(yAxis);


  // Automatic label placement
  var labeler = d3.labeler()
      .label(svg.selectAll("text.label" + index))
      .start();
  labeler.label()
      .transition()
      .duration(0)
      .attr("x", function(d, i) { 
        return this.alpx; 
      })
      .attr("y", function(d, i) { 
        return this.alpy; 
      });

  addTitle(svg);


});     
