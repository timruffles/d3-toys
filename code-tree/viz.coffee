width = document.body.clientWidth * 0.9
height = document.body.clientHeight * 0.8

color = d3.scale.category20()
svg = d3.select("body").append("svg").attr("width", width).attr("height", height).append("g").attr("transform","translate(10,30)")

d3.json "deps.json", (json) ->

	nodes = Object.keys(json).map((k) ->
		deps = json[k]
		name: k
		deps: deps
		clients: []
	)

	byId = nodes.reduce ((byId, node) ->
		byId[node.name] = node; byId
	), {}

	seenBefore = {}

	nodes.forEach (node) ->
		node.deps.forEach (dep) ->
			byId[dep] ||= {name: dep, deps: [], clients: []}
			patron = byId[dep]
		node.deps = node.deps.map (depName) -> 
			dep= byId[depName]
			dep.clients.push(byId[node.name])
			if seenBefore[depName]
				{name: dep.name}
			else
				seenBefore[depName] = true
				dep

	tree = d3.layout.tree()
	tree.children (node) -> node.deps
	tree.size [width,height]

	link = d3.svg.diagonal()
		 .projection((d) ->
			 [d.x, d.y]
		 )

	xScale = d3.scale.linear().range([25,width])
	yScale = d3.scale.linear().range([25,height])

	draw = (drawNode) ->

		fromMain = tree.nodes(byId[drawNode])
		linksFromMain = tree.links(fromMain)

		svg.selectAll(".link").remove()
		svg.selectAll(".node").remove()

		links = svg.selectAll(".link")
			.data(linksFromMain)

		links.enter()
			.append("svg:path")
			.attr("class", "link")
			.attr("d", link)

		links.exit().remove()


		tooltip = (data) ->

			tt = d3.select("body")
				.selectAll("#tooltip")
				.data(data)

			enteringTooltip = tt.enter()
				.append("div")
				.attr("id","tooltip")
				.attr("class","pane")

			enteringTooltip.append("h3")
			enteringTooltip.append("h4")

			tt.select("h3")
				.text((d) -> d.node.name )

			tt.select("h4")
				.text((d) -> clientCount = (byId[d.node.name].clients || []).length; return "No clients" if clientCount == 0; "Called by #{clientCount}")

			enteringTooltip.append("ul")

			tt.style("left",(d) -> d.left || d3.select(this).attr("left"))
				.style("top",(d) -> d.top || d3.select(this).attr("top"))
				.transition()
					.style("opacity",(d) -> return 1 if d.shown; 0 )

			clients = tt
				.selectAll("li")
				.data((d) -> byId[d.node.name].clients || [])
				.on("click",(d) ->
					draw d.name
				)

			clients.enter()
				.append("li")

			clients.text((d) -> d.name || d)

			clients.exit()
				.remove()

		nodes = svg.selectAll(".node")
			.data(fromMain)


		nodes.exit().remove()

		nodesEnter = nodes
			.enter()
				.append("g")
				.attr("transform",(d) ->
					"translate(#{d.x},#{d.y})"
				)
				.attr("class","node")
				.on("mouseover", (node) ->
					bounding = this.getBoundingClientRect()
					d3.select(this).select("text").transition().attr("opacity",1)
					tooltip([{top: bounding.top + 10, left: bounding.left, node: node, shown: true}])
				)
				.on("mouseout",->
					setTimeout =>
						d3.select(this).select("text").transition().attr("opacity",0)
						d3.select("#tooltip").style("opacity",0)
					, 10000
				)
		
		nodesEnter.append("circle")
			.attr("r",5)
			.style("fill","red")

		nodesEnter
			.append("text")
			.attr("opacity",0)
			.attr("transform",(d) ->
				bounding = this.getBoundingClientRect()
				"translate(#{-bounding.width/2},-10)"
			)
			
	draw "main"

	window.draw = draw

		
