<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/benchmarks">
    <html>
      <head>
        <title>Benchmarks - Benchart</title>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/1.0.2/Chart.js" type="text/javascript"/>
        <script type="text/javascript">
        //<![CDATA[
          window.addEventListener("load", function () {

            function getColor(index) {
              function f(i) {
                i %= 12;
                if (i >= 6)
                  i = 12 - i;
                return ([ 220, 220, 220, 110 ])[i] || 0;
              }
              return [f(index), f(index + 8), f(index + 4)].join(",");
            }

            function getData() {
              var root = document.getElementById("data").childNodes[0];
              // gather all data to benchmarks
              var benchmarks = [];
              for (var i = 0; i != root.childNodes.length; ++i) {
                if (root.childNodes[i].nodeType != 1)
                  continue;
                var set = root.childNodes[i];
                var target = {
                  name: set.getAttribute("name"),
                  scores: {}
                };
                for (var j = 0; j != set.childNodes.length; ++j) {
                  if (set.childNodes[j].nodeType != 1)
                    continue;
                  var score = set.childNodes[j];
                  target.scores[score.getAttribute("name")] = score.getAttribute("value");
                }
                benchmarks.push(target);
              }
              // build list of labels
              var labels = (function () {
                var m = {};
                for (var i in benchmarks)
                  for (var j in benchmarks[i].scores)
                    m[j] = 1;
                return Object.keys(m);
              })();
              // build the data
              return {
                labels: labels,
                datasets: benchmarks.map(function (set, index) {
                  var color = getColor(index);
                  return {
                    label:           set.name,
                    data:            labels.map(function (name) {
                      return set.scores[name] || 0;
                    }),
                    fillColor:       "rgba(" + color + ",0.5)",
                    strokeColor:     "rgba(" + color + ",0.8)",
                    highlightFill:   "rgba(" + color + ",0.75)",
                    highlightStroke: "rgba(" + color + ",0.1)"
                  };
                })
              };
            }

            var ctx = document.getElementById("chart").getContext("2d");
            var chart = new Chart(ctx).Bar(getData(), {
              bezierCurve:    false,
              legendTemplate: "<% for (var i = 0; i < datasets.length; i++){ if (i != 0) %> / <% ; %><span style=\"background-color:<%=datasets[i].fillColor%>\">&#160;&#160;&#160;</span><%if(datasets[i].label){%> <%=datasets[i].label%><%}%><% } %>"
            });
            document.getElementById("legend").innerHTML = chart.generateLegend();

          });
        //]]>
        </script>
        <style type="text/css">
          body {
            text-align: center;
          }
        </style>
      </head>
      <body>
        <canvas id="chart" width="400" height="400"/>
        <div id="legend"/>
        <div id="data" style="display: none;">
          <xsl:copy-of select="/benchmarks"/>
        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
