\ Platforming example!  Based on mapex.f, which just loads and displays a tilemap.  This goes
\ to the next logical step.

empty
include le/le
include le/oe/tiled

le: idiom platformex:
    import ex/le/lk/kevin
    import le/mo/tilcd
    
soft  320 240 *bmp value framebuf
map testmap ex/le/lk/test.tmx

: pre-mag   grey backdrop  framebuf onto  black backdrop ;
: mag       framebuf onto  draw-world ;
: post-mag  displayw 320 3 * - 0 at  white  framebuf dup bmpwh 3 3 2* sblit ;

devoid scene
crisp testmap open  0 layer[] 0 0 get

' pre-mag is prerender
' mag is render
' post-mag is postrender


0 0 at one tilemap named mytm  tilemap: 320 240 mw 2v!

platformex:
20 20 at  one kevin named p1


:noname [ is poststep ] eachlist> 20 collide-objects-map ;

interact off
