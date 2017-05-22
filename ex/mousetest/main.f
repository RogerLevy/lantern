[undefined] [bu] [if]
    include core/core
[then]

idiom [dumb]

include examples/dumbtest/words
import mo/flood
include sa/keyboard


: riser  create 0 , does> dup push +!  pop @ ;
riser r
riser b

variable rad  5 rad !

variable x
variable y

: orb  x @ y @ 2af  rad @ 1 max 1af   1 1 1 1 4af  -1 1af al_draw_circle
       x @ y @ 1 0 0 1 al-floodfill ;

: logic  step
    <left> kstate if  -1 x +! then
    <right> kstate if  1 x +! then
    <up> kstate if  -1 y +! then
    <down> kstate if  1 y +! then
    <-> kstate if -0.5 rad +! then
    <=> kstate if 0.5 rad +! then
    ;
: dumb  go  logic  show  0.004 r 0 0.014 b clear-to-color  orb ;

cr .( Just some little instructions: )
cr .( left-up-right-down moves the circly guy )
cr .( - and + makes him grow and shrink )
cr .( note: you can't control the game until you TAB into it - screen will turn green )
cr .( note 2: it's slow when he's big because we're demo-ing a quick-n-dirty software-based floodfill algorithm )
cr .(    other than that, trust that this is a HW-accelerated graphics context ;] )

dumb 


