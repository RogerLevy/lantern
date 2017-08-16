\ [x] - A way to convert tiles on extraction

empty
include le/le
include le/oe/tiled

soft  320 240 *bmp value framebuf
map testmap ex/le/lk/test.tmx

: chest  draw>  2 tile 3 ublit ;

: pre-mag   grey backdrop  framebuf onto  black backdrop ;
: mag       framebuf onto  draw-world ;
: post-mag  displayw 320 3 * - 0 at  white  framebuf dup bmpwh 3 3 2* sblit ;

devoid scene
crisp testmap open  0 layer[] 0 0 get

' pre-mag is prerender
' mag is render
' post-mag is postrender

150 100 at one chest

0 0 at one tilemap named mytm
    tilemap: 320 240 mw 2v!
    : scroll  act>  1 sx udlr  sx 2v@ 0 0 2max sx 2v! ; scroll

0 objgroup[]  load-objects
