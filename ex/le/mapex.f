\ [ ] - A way to convert tiles on extraction

empty
include le/le
import le/mo/loadtmx

soft  320 240 *bmp value framebuf
2048 2048 array2d tilebuf


" ex/le/lk/test.tmx" opentmx
crisp  load-tiles
    0 layer[]  0 0 tilebuf addr-pitch  extract   \ extract tilemap.  we assume layer 0 exists.
    0 0 1024 1024 tilebuf convert-tilemap
    scene  0 objgroup[]  load-objects

var sx var sy

: chest  draw>  2 tile 3 ublit ;

: tilemap
    act>
        <up> kstate if -1 sy +! then
        <down> kstate if  1 sy +! then
        <left> kstate if -1 sx +! then
        <right> kstate if  1 sx +! then
        sx 2v@ 0 0 2max sx 2v!
    draw>
        0 0 at
        at@ 320 240 scaled clip>
        sx 2v@ 20 20 scroll tilebuf addr  tilebuf @pitch  draw-tilemap-bg ;

: pre-mag   grey backdrop  framebuf onto  black backdrop ;
: mag       framebuf onto  draw-world ;
: post-mag  0 0 at  white  framebuf dup bmpwh 3 3 2* sblit ;

scene
' pre-mag is prerender
' mag is render
' post-mag is postrender

50 50 at one chest
0 0 at one tilemap named mytm

