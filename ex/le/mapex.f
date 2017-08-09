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

: scroll  ( scrollx scrolly tilew tileh pen=xy -- col row pen=offsetted )
    2over 2over 2mod 2negate +at   2/ 2pfloor ;

: @pitch  ( array2d -- /pitch )  numcols @ cells ;

: tilemap
    act>
        <up> kstate if -1 sy +! then
        <down> kstate if  1 sy +! then
        <left> kstate if -1 sx +! then
        <right> kstate if  1 sx +! then
    draw>  0 0 320 240 scaled clip>  sx 2v@ 20 20 scroll tilebuf addr  tilebuf @pitch  draw-tilemap-bg ;

\ 3X scaling
transform m0  m0 3 3 2af  al_scale_transform
: magnified  grey backdrop  m0 al_use_transform  ;

scene
' magnified is prerender
50 50 at one chest
0 0 at one tilemap named mytm

