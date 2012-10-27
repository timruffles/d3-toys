buster = require("buster")
heat = require("./heat-layout")


buster.testCase "Heat",
	"it gives heat": ->
		data = [
			{x: 10, y: 10},
			{x: 12, y: 14},
		]
		mapped = heat data, {}
		console.log mapped
		assert mapped.length > 0
