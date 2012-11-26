

es = require "esprima"

code = """
	define([
		'm/slice/performance',
		'm/slice/merchants',
		'constants'
	],function(
		PerformanceSlice,
		MerchantsSlice,
		c
	) {
		var Query = Backbone.ValueObject.extend({
		},{
			create: function(attrs,opts) {
				var k = function(k) { return (attrs && attrs[k]) || opts && opts.current && opts.current.get(k) };
				require(["m/foo"],function() {});
			}
		});
	});
"""


traverse = (node,fn) ->
	fn node
	for own k,v of node
		if typeof v == "object" && v != null
			traverse v, fn
	null

fs = require "fs"
dir = process.argv[2]


read = (dir,rel = "") ->
	depsByPath = {}
	files = fs.readdirSync dir

	files.forEach (file) ->
		allDeps = []
		path = dir + "/" + file
		stat = fs.statSync(path)
		if stat.isDirectory()
			dirDeps = read path, rel + "/" + file
			for own file, deps of dirDeps
				depsByPath[file] = deps
			return

		return unless /\.js$/.test file

		try
			parsed = es.parse(fs.readFileSync(path,"utf8"))
		catch e
			console.error "Error parsing #{path}: #{e}"
			return

		traverse parsed, (node) ->
			return if node.type != "CallExpression" || !(node.callee.name of {"define":1,"require":1})
			deps = node.arguments.filter (arg) ->
				arg.type == "ArrayExpression"
			if deps.length > 0
				deps = deps[0].elements.map (dep) -> dep.value
			else
				deps = []
			allDeps = allDeps.concat deps

		depsByPath[(rel + "/" + file.replace(/\.js$/,"")).replace(/^\//,"")] = allDeps
	depsByPath


console.log JSON.stringify read dir
