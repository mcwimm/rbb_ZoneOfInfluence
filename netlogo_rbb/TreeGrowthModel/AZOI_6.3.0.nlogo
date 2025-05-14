globals
[
  ; parameters for the initialisation of individuals
  Bmax-mean
  Bmax-sd
  Bo-mean
  Bo-sd
  r-mean
  r-sd

  ; parameters and global variables for the hexagonal packing:
  x-hex
  y-hex
  i-hex
  j-hex
  spacingx
  spacingy
  y-offset

  size-factor    ;; depending on the grid size, take care of the sizes of individuals
]

turtles-own
[
  Bmax   ;;maximum biomass
  B      ;;biomass
  r      ;;growth rate
  Ae    ;;effective area
  rad    ;; radius
  ;;the display radius is stored in size / 2
  pot-dead  ;; plants with gr of 0 will have this value true
]

patches-own[nb-sharing]





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            setup                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all
  ;random-seed 10020
  set-default-shape turtles "circle"
  set Bmax-mean 20000
  set Bmax-sd 2000
  set Bo-mean 1.0
  set Bo-sd 0.1
  set r-mean 1.0
  set r-sd 0.1


  ask patches [set nb-sharing 0]

  set size-factor ((world-width) / 100)

  if regular-organisation
  [
     set j-hex  factor density
     set i-hex density / (2 * j-hex)
     set spacingx world-width / (2 * i-hex)
     set spacingy world-height / (2 * j-hex)
     set x-hex spacingx / 2
     set y-hex spacingy / 2
     set y-offset spacingy / 2
  ]


  crt density
  [
    set B random-normal Bo-mean Bo-sd
    set Bmax random-normal Bmax-mean Bmax-sd
    set r random-normal r-mean r-sd
    set rad ( B ^ (2 / 6) ) * ( PI ^ ( -1 / 2 ) )
    set Ae ( B ^ (2 / 3) )
    set size rad * size-factor * 2
    set pot-dead false
    ifelse regular-organisation
    [ hexagonal ]
    [ setxy random-xcor random-ycor ]
    set color scale-color green size (( size-factor * ( ( Bo-mean + 2 * Bo-sd ) ^ ( 2 / 3 ) ) ) * 0.1 )   (( size-factor * ( ( Bo-mean + 2 * Bo-sd ) ^ ( 2 / 3 ) ) ) * 2)
  ]

  if grid [print-grid]

  reset-ticks
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                  go stuffs                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go

  ifelse asymmetric-competition
  [
    ask patches [set nb-sharing 10000]
    ask turtles [attribute-grids]
    ask turtles [zoi-asym]
  ]
  [
    ask patches [set nb-sharing 0]
    ask turtles [share-grids]
    ask patches with [nb-sharing > 0] [set nb-sharing 1 / nb-sharing]
    ask turtles [zoi-sym]
  ]
  ask turtles [grow]

  auto-plot-on

  set-current-plot "Histogram of sizes of individuals"
  histogram [B] of turtles

  set-current-plot "Coefficient of variation of mass through time"
  plotxy (ticks + 1)  (100 * standard-deviation [B] of turtles / mean [B] of turtles )

  set-current-plot "Mean mass through time"
  plotxy (ticks + 1) mean [B] of turtles


  set-current-plot "self-thinning pattern"
  plotxy (ln count turtles with [pot-dead = false]) (ln mean [B] of turtles with [pot-dead = false])
  tick
end


to go-30
  repeat 30
  [
    go
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;              growth                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to grow
    let gr r * ( Ae - ( ( B ^ 2 ) / ( Bmax ^ ( 4 / 3 ) ) ) )
    ifelse gr > 0
    [
        set B ( B + gr )
        set rad ( B ^ (2 / 6) ) * ( PI ^ ( -1 / 2 ) )
        set size rad * size-factor * 2
    ]
    [
        ;show "negative gr"
        set pot-dead true
    ]

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; asymmetrical competition calculation of effective area  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to zoi-asym
  let nbtot (count patches in-radius (size / 2))
  let nbsh  (count patches in-radius (size / 2) with [nb-sharing = [who] of myself])
  if nbsh > nbtot [show "problemmmmmm!!!!"]
  ifelse nbsh = 0
  [ set Ae 0 ]
  [ set Ae ( B ^ (2 / 3) ) * nbsh / nbtot ]
end

to attribute-grids
  ask patches in-radius (size / 2)
  [
    ifelse nb-sharing = 10000
    [
      set nb-sharing [who] of myself
    ]
    [
      ifelse ([size] of turtle (nb-sharing)) > [size] of myself
      [
        ;;do nothing
      ]
      [
        set nb-sharing [who] of myself
      ]
    ]
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; symmetrical competition calculation of effective area  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to zoi-sym
  let nbtot (count patches in-radius (size / 2))
  let nbsh  (sum ([nb-sharing] of patches in-radius (size / 2)))
  set Ae ( B ^ (2 / 3) ) * nbsh / nbtot
end

to share-grids
  ask patches in-radius (size / 2)
  [set nb-sharing nb-sharing + 1]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; hexagonal packing installation ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to hexagonal
  ifelse y-hex > world-height
  [    show "too many point"  ]
  [
    setxy x-hex y-offset ;install at the prepared spot
    ;prepare the next one...
    set x-hex x-hex + spacingx
    ifelse y-offset = y-hex
    [  set y-offset y-offset + spacingy ]
    [  set y-offset y-hex ]

    if x-hex > world-width
    [    set x-hex spacingx / 2
         set y-hex y-hex + 2 * spacingy
         set y-offset y-hex
    ]
  ]
end

to-report factor [n]  ;; return the smallest integer divider of n larger than its square root (translated directly from Weiner's code)
  let root floor(sqrt(n))

  while [(n / root) < root] [
   set root root + 1
  ]
  report root
end




;; display stuffs
to print-grid
  ask patches with [remainder (pxcor + pycor ) 2 > 0 ]
  [
    set pcolor grey
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
268
10
776
519
-1
-1
1.0
1
10
1
1
1
0
1
1
1
0
499
0
499
1
1
1
ticks
30.0

BUTTON
74
10
129
43
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
6
10
69
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
133
10
188
43
NIL
go-30
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
7
53
194
86
regular-organisation
regular-organisation
1
1
-1000

CHOOSER
8
133
146
178
density
density
100 506 992 4970
2

PLOT
796
12
1239
339
Histogram of sizes of individuals
classes
Frequency
0.0
3000.0
0.0
100.0
true
false
"" ""
PENS
"default" 100.0 1 -8630108 true "" ""

SWITCH
157
138
260
171
grid
grid
1
1
-1000

SWITCH
7
92
193
125
asymmetric-competition
asymmetric-competition
1
1
-1000

PLOT
797
343
1240
549
Coefficient of variation of mass through time
time
CV %
0.0
30.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

BUTTON
193
10
248
43
go-once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
11
183
261
539
Mean mass through time
time
Mass
0.0
30.0
0.0
1250.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" ""

PLOT
10
546
262
733
self-thinning pattern
log density
log biomass
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 2 -16777216 true "" ""

MONITOR
1093
30
1232
75
Maximum individual biomass
max [B] of turtles
2
1
11

MONITOR
919
30
1090
75
Minimum individual biomass (alive)
min [B] of turtles with [pot-dead = false]
2
1
11

TEXTBOX
300
557
760
583
AZOI model, reimplementation of the ZOI model of Weiner et al. (2001)
14
13.0
1

@#$#@#$#@
## LOGBOOK :

This AZOI model started to be re-implemented in Bad Schandau the 11/10/2007 as "side-activity" of an ABM/IBM course we were teaching with Volker, Steve and Uta. The first developped procedures were the setup and go with a linear growth. On the same day later I could arrive to a model already growing organisms relatively well with the implementation of the growth function according to Weiner et al. 2001  
# hours ~ 5h

12/10:	
	- Implementation of the ZOI grid area to calculate interactions effect on growth (working with Weiner's definition of symmetric competition). A problem I encountered was the size of the cells and the numbers to do... Netlogo has obvious problems with large numbers of patches.  
# hours ~ 7h

14/10:	
	- work on trials to install hexagonal packing (not successfull)  
# hours ~ 2h

25/10:	
	- implement the installation following hexagonal packing (with the help of the original C script from Weiner's code (to find in http://www.jacobweiner.dk/Site/Research.html )  
# hours ~ 2h
	- work on the analysis and graphs. Could reproduce most of results (except mass exact scale, but not very far...)  
# hours ~ 1h
	- implement an asymmetric competition growth with some trick of patch assignment... have to check if really works! but so far looks like it does...  
# hours ~ 2h
	- spent 1h more on playing around and fixing few small bugs...  
# hours ~ 1h

26/10:
	- correct some few bugs, try to fit to the biomass of Weiner but miss ~10% with low density... cannot find where from. Another problem is that with high density some individuals get bigger than the biggest ones with low density... I will need to run replicates to check if this is always so, or just an artefact of the starting conditions.
	- create a graph to see the self-thinning process considering that individuals with gr=0 are dead (can show the results of Stoll et al. 2002)
	- and run a behavior space analysis for all combinations (except density 4000), 30 replicates each saving the biomass of all individuals (preparation 5min, run 7h)   
# hours ~ 2h 

29/10:
	-analyze the result of the behavior space analysis. Confirm that the results are identical than for Weiner et al. 2001. Create histograms of biomass, graph of CV against density and analyze also the skewness. I could identify that the problem described above ("is that with high density some individuals get bigger than the biggest ones with low density") is only occuring with asymmetric competition, so it is not a problem: at high densities the joined competition of larger plants outcompete faster the smaller ones, and thus allow the bigger ones to grow faster.
	-Except if the co-authors disagree I consider I can stop here...  
# hours ~ 4h

## SUM OF HOURS:

26 hours


## REFERENCES:

J. Weiner, P. Stoll, H. Muller-Landau, and A. Jasentuliyana, 2001. The effects of density, spatial pattern, and competitive symmetry on size variation in simulated plant populations. The American Naturalist, 158:438-450

P. Stoll1, J. Weiner, H. Muller-Landau, E. M�ller and T. Hara, 2002. Size symmetry of competition alters biomass�density relationships. Proceedings of the Royal Society, London Series B, 269:2191-2195


@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="all possibilities" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="30"/>
    <metric>mean [B] of turtles</metric>
    <metric>[B] of turtles</metric>
    <enumeratedValueSet variable="regular-organisation">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="asymmetric-competition">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="grid">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="density">
      <value value="100"/>
      <value value="506"/>
      <value value="992"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
