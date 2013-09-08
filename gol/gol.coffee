life = ({w,h,nodes}) ->

	nodes ||= []
	nodes = nodes.reduce (all,node) ->
		all["#{node.x},#{node.y}"] = node
		all
	, {}

	range = (start,end,increment = 1) ->
		x for x in [start..end] by increment

	{min,max} = Math

	allPoints = range(0,w).reduce (points,x) ->
		range(0,h).forEach (y) -> points.push {x,y}
		points
	, []

	tap = (x) -> console.log x; x
			
	node = ({x,y}) -> nodes["#{x},#{y}"]
	die = (point) -> delete nodes["#{point.x},#{point.y}"]
	birth = (point) -> nodes["#{point.x},#{point.y}"] = point

	neighbours = ({x,y}) ->
		[-1,0,1].reduce (points,dx) ->
			[-1,0,1].forEach (dy) ->
				candidate = {x: x+dx,y:y+dy}
				if (dx != 0 || dy != 0) and node(candidate)
					points.push candidate
			points
		, []

	->

		newNodes = {}

		updated = allPoints.map (point) ->
			neighbourCount = neighbours(point).length
			coords = "#{point.x},#{point.y}"
			alive = if nodes[coords]
				1 < neighbourCount < 4
			else
				neighbourCount == 3
			newNodes[coords] = point if alive
			{x:point.x,y:point.y,alive: alive}

		nodes = newNodes

		updated


draw = ({w,h,cellDim}) ->

	svg = d3.select("body")
		.append("svg")
		.attr({width:w,height:h})

	spaceship = [
		[2,0],[2,1],[2,2],
		[1,2],
		[0,1]
	]

	nodes = spaceship.map ([x,y]) -> {x,y}

	gol = life ({w:50,h:50,nodes:nodes})

	frame = ->
		data = gol()

		cells = svg.selectAll("rect")
			 .data(data,({x,y}) -> "#{x},#{y}")

		cells.enter()
			 	.append("rect")
				.attr({width: cellDim,height: cellDim})
				.attr("transform",({x,y},i) ->
					"translate(#{x * cellDim},#{y * cellDim})"
				)

		cells.attr("fill",(point) ->
			(point.alive && "#FF0000") or "#000"
		)

	setInterval frame, 500

draw({w:document.body.clientWidth,h:document.body.clientHeight,cellDim:15})

