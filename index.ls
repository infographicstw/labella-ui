<- $ document .ready

$(\#data).val("""time,name
1977/4/25,A New Hope
1980/4/17,The Empire Strikes Back
1984/4/25,Return of the Jedi
1999/4/19,The Phantom Menace
2002/4/16,Attack of the Clones
2005/4/19,Revenge of the Sith
2015/11/18,The Force Awakens
""")

data = []
box = document.body.getBoundingClientRect!
d3.select \#svg .attr do
  width: box.width - 40
  height: \300px

color = d3.scale.ordinal!range <[#65ad38 #efb639 #e02d1f #771d18 #333333]>
redraw = ->
  $(\#svg).html("")
  chart = new d3KitTimeline('#svg', {
    direction: 'down'
    layerGap: 20
    initialWidth: box.width - 60
    initialHeight: box.height - 40
    labella: {maxPos: box.width - 160}
    labelBgColor: (d,i) -> color d.name
    linkColor: (d,i) -> d3.rgb(color d.name).darker!toString!
    dotColor: (d,i) -> d3.rgb(color d.name).darker!toString!
    labelTextColor: (d,i) -> 
      hsl = d3.hsl(color d.name)
      return if hsl.l < 0.55 => \#fff else \#333
    textFn: (d) -> return d.time.getFullYear! + ' - ' + d.name
  })
  data.filter(-> it.time and it.name).map -> it.time = new Date(it.time)
  chart.data(data).resizeToFit!
  d3.select \.main-layer .attr do
    transform: "translate(0, 20)"

handle = ->
  val = $(\#data).val!trim!
  result = []
  Papa.parse (val or ""), do
    worker: true, header: true
    step: ({data: rows}) ~> result ++= rows
    complete: ~>
      data := result
      redraw!

$(\#data).on \change, handle
$(\#data).on \keydown, handle
$(\#data).on \keypress, handle

handle!

ldColorPicker.init!

ldcp = new ldColorPicker(
  document.getElementById(\cpbtn)
  {
    class: "left"
    palette: <[#65ad38 #efb639 #e02d1f #771d18 #333333]>
    onpalettechange: -> 
      color := d3.scale.ordinal!range(it.colors.map -> it.hex)
      redraw!
  }

)
