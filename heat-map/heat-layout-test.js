// Generated by CoffeeScript 1.3.1
var buster, heat;

buster = require("buster");

heat = require("./heat-layout");

buster.testCase("Heat", {
  "it gives heat": function() {
    var data, mapped;
    data = [
      {
        x: 10,
        y: 10
      }, {
        x: 12,
        y: 14
      }
    ];
    mapped = heat(data, {});
    console.log(mapped);
    return assert(mapped.length > 0);
  }
});