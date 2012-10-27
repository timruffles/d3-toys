heatMap = (data,{width,height}) ->

	map = {}

	heat = (point,incr = 0) ->
		map[point.toString()] ||= 0
		map[point.toString()] += incr

	class Point
		constructor: (@x,@y) ->
			Object.freeze && Object.freeze(this)
		toString: ->
			"#{@x},#{@y}"

	{sqrt,pow} = Math

	for {x,y} in data
		point = new Point(x,y)

		levels = 3

		spread = (other) ->
			pow(2,-( pow(point.x - other.x,2) + pow(point.y - other.x,2) ))
			
		for r in [0..levels]
			for x in [point.x-r..point.x+r]
				for y in [point.y-r..point.y+r]
					p = new Point(x,y)
					heat p, spread(p)

	for datum in data
		datum.heat = heat new Point(datum.x,datum.y)

	data
				
				
			
module.exports = heatMap
