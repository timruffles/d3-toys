peek = (x) ->
	console.log x
	x

heatMap = ({width,height,levels}) ->

	map = {}

	coord = (x,y) ->
		x * height + y
	
	nodes = []
	for x in [0...width]
		for y in [0...height]
			nodes.push {x,y,heat:0,coords: "#{x},#{y}"}

	{sqrt,pow,max,min} = Math

	cool = (delta) ->
		mult = max(1 - (1 * (delta / 450)),0)
		for own coords, _ of map
			node = nodes[coords]
			if mult > 0 && node.heat > 1e-5
				node.heat *= mult
			else
				node.heat = 0
				delete map[coords]
		false


	spread = (x1,y1,x2,y2) ->
		pow(2, -( pow(x1 - x2,2) + pow(y1 - y2,2) ) )

	warm = (data) ->
		for datum in data
			x1 = datum.x
			y1 = datum.y
			added = {}
			for r in [0..levels] by 1
				for x2 in [max(x1-r,0)..min(x1+r,width-1)] by 1
					for y2 in [max(y1-r,0)..min(y1+r,height-1)] by 1
						point = coord x2,y2
						if not (point of added)
							nodes[point].heat += spread(x1,y1,x2,y2)
							map[point] = true
							added[point] = true

		nodes


	return ({delta,nodes}) ->
		cool delta if delta
		warm nodes if nodes

	
				
			
if this.module
	module.exports = heatMap
