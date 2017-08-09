\ [ ] - A way to convert tiles on extraction

empty
include le/le
\ le: idiom mapex:
import le/mo/loadtmx

" ex/le/lk/test.tmx" opentmx
load-tiles
2048 2048 array2d tilebuf 
0 layer[]  0 0 tilebuf addr  2048 cells  extract   \ extract tilemap.  we assume layer 0 exists.
tilebuf convert-map
scene  0 objgroup[]  load-objects

var sx var sy

: chest  draw>  2 tile blit ;

: tilemap  draw>  0 0 320 240 scaled clip>  0 0 tilebuf addr  2048 cells  draw-tilemap ;

\ 3X scaling
transform m0  m0 3 3 2af  al_scale_transform
: magnified  grey backdrop  m0 al_use_transform  ;

scene
' magnified is prerender
50 50 at one chest
0 0 at one tilemap named mytm

