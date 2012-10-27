


map = ({el,width,height,data,xMax,yMax}) ->

	g = d3.select("body")
		.append("svg")
		.attr("width",width)
		.attr("height",height)


	nodes = heatMap(data,{width: xMax, height: yMax})

	extent = (k) ->
		d3.extent(_.pluck(nodes,k))

	colorScale = d3.scale.sqrt().domain(extent "heat").range(["#FFFFFF","#A7FF08"])

	nodeWidth = width / xMax
	nodeHeight = height / yMax

	nodeDims = Math.min(nodeWidth,nodeHeight)
	squareDims = Math.min(width,height)

	xScale = d3.scale.linear().domain([0,xMax]).range([0,squareDims - nodeDims])
	yScale = d3.scale.linear().domain([0,yMax]).range([0,squareDims - nodeDims])
	
	g.selectAll("rect")
	 .data(nodes)
	 .enter()
	 .append("rect")
	 .attr("transform",((d) ->
		  "translate(#{xScale d.x},#{yScale d.y})"
	 ))
	 .attr("fill", (d) ->
		 colorScale d.heat
	 )
	 .attr("data-xy",(d) -> d.x + "," + d.y  + "-" + d.heat)
	 .attr("width", nodeDims)
	 .attr("height", nodeDims)


map
	width: document.body.clientWidth
	height: document.body.clientHeight
	xMax: 30
	yMax: 30
	data: data = [
		{x: 15, y: 20}
		{x: 18, y: 20}
		{x: 21, y: 20}
		{x: 19, y: 20}
		{x: 19, y: 23}
		{x: 19, y: 21}
		{x: 20, y: 21}
		{x: 20, y: 21}
		{x: 20, y: 21}
		{x: 20, y: 21}
	]
