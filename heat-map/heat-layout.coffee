heatMap = (data,{width,height}) ->

	map = {}

	heat = (point,incr = 0) ->
		map[point.toString()] ||= {x: point.x, y: point.y, heat: 0}
		map[point.toString()].heat += incr

	class Point
		constructor: (@x,@y) ->
			Object.freeze && Object.freeze(this)
		toString: ->
			"#{@x},#{@y}"

	{sqrt,pow} = Math

	for datum in data
		datum.heat = 0
		{x,y} = datum
		point = new Point(x,y)
		map[point.toString()] = datum

		levels = 4

		spread = (other) ->
			pow(3, -( sqrt( pow(point.x - other.x,2) + pow(point.y - other.y,2) ) ) )
			
		added = {}
		for r in [0..levels]
			for x in [point.x-r..point.x+r]
				for y in [point.y-r..point.y+r]
					p = new Point(x,y)
					if not (p.toString() of added)
						heat p, spread(p)
						added[p.toString()] = true

	nodes = []
	for x in [0..width]
		for y in [0..height]
			nodes.push map[x+","+y] || {x,y,heat:0}
	nodes
	
	
				
			
if this.module
	module.exports = heatMap
