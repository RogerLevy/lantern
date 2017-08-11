\ [ ] - A way to convert tiles on extraction

empty
include le/le
import le/mo/tilemap

soft  320 240 *bmp value framebuf
map testmap ex/le/lk/test.tmx

crisp testmap open  0 layer[] 0 0 read
scene  0 objgroup[]  load-objects

: chest  draw>  2 tile 3 ublit ;

: pre-mag   grey backdrop  framebuf onto  black backdrop ;
: mag       framebuf onto  draw-world ;
: post-mag  0 0 at  white  framebuf dup bmpwh 3 3 2* sblit ;

scene
' pre-mag is prerender
' mag is render
' post-mag is postrender

50 50 at one chest

0 0 at one tilemap named mytm
    tilemap: 320 240 mw 2v!
    : scroll
        act>
        <up> kstate if -1 sy +! then
        <down> kstate if  1 sy +! then
        <left> kstate if -1 sx +! then
        <right> kstate if  1 sx +! then
        sx 2v@ 0 0 2max sx 2v! ; scroll


