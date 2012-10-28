


map = ({el,width,height,data,xMax,yMax}) ->

	g = d3.select("body")
		.append("svg")
		.attr("width",width)
		.attr("height",height)


	map = heatMap({width: xMax, height: yMax,levels: 2})

	extent = (k) ->
		d3.extent(_.pluck(data,k))

	colorScale = d3.scale.sqrt().domain([0,0.5,1]).range(["#0A88FF","#00FF27","#FF0000"])

	nodeWidth = width / xMax
	nodeHeight = height / yMax

	nodeDims = Math.min(nodeWidth,nodeHeight)
	squareDims = Math.min(width,height)

	xScale = d3.scale.linear().domain([0,xMax]).range([0,squareDims - nodeDims])
	yScale = d3.scale.linear().domain([0,yMax]).range([0,squareDims - nodeDims])

	parseDec = (x) ->
		parseInt x, 10

	coord = (x,y) ->
		x + y * 30
	

	g.on("click",(d,i,e) ->
		el = d3.event.target
		coords = el.getAttribute("data-xy")
		[all,x,y] = /^(\d+),(\d+)/.exec(coords)
		data.push { x:parseDec(x),y:parseDec(y) }
	)

	points = g.selectAll("rect")

	{cos,sin,max,min,round,random,PI} = Math

	randomInt = (n) ->
		round(random() * n)

	observer = d3.random.normal(PI / 2,0.5)

	peek = (x) ->
		console.log x
		x

	randomObserver = ->
		rads = observer()
		console.log rads
		peek {x: min(round(cos(rads) * 14) + 14,29), y: min(round(sin(rads) * 8) + 2,29)}

	last = false
	setInterval run = ->

		for n in [1..randomInt(2)] by 1
			data.push randomObserver()
			
		time = new Date().getTime()
		last ||= time
		delta = time - last

		points = points
		 .data(map(delta: delta, nodes: data),((d) ->
			 d.x + "," + d.y
		 ))

		points
		 .enter()
		 .append("rect")
		 .attr("transform",((d) ->
				"translate(#{xScale d.x},#{yScale d.y})"
		 ))
		 .attr("data-xy",(d) -> d.x + "," + d.y  + "-" + d.heat)
		 .attr("width", nodeDims)
		 .attr("height", nodeDims)

	  points
		 .attr("fill", (d) ->
			 colorScale d.heat
		 )

		data = []
		last = time

		false


map
	width: document.body.clientWidth
	height: document.body.clientHeight
	xMax: 30
	yMax: 30
	data: data = [
	]
