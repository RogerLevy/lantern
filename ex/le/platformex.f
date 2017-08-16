\ Platforming example!  Based on mapex.f, which just loads and displays a tilemap.  This goes
\ to the next logical step.

empty
include le/le
include le/oe/tiled         \ extend lantern with Tiled support

le: idiom platformex:
    import ex/le/lk/kevin   \ character script

\  Variables
soft  320 240 *bmp value framebuf
map testmap ex/le/lk/test.tmx
objlist bg1

\  Scene setup
devoid scene
    crisp testmap open  0 layer[] 0 0 get
    bg1 in  0 0 at one tilemap named mytm  tilemap: 320 240 mw 2v!  platformex:
    objects in  20 20 at  one kevin named p1

\  Scrolling
: scrollxy  p1 's x 2v@   160 120 2-  0 0 2max ;
: movecam  scrollxy mytm scroll-tilemap ;
transform m0
: scroll>  m0 al_identity_transform  m0 scrollxy 2negate 2af al_translate_transform  m0 al_use_transform  r> call  1-1 ;

\  Main loop configuration; COLLIDE-OBJECTS-MAP enables tilemap collisions in conjunction with HITMAP> (see kevin.f)
:noname [ is prerender ]  grey backdrop  framebuf onto  black backdrop ;
:noname [ is render ]     movecam        framebuf onto  1-1 bg1 draw-objlist  scroll>  objects draw-objlist ;
:noname [ is postrender ] displayw 320 3 * - 0 at  white  framebuf dup bmpwh 3 3 2* sblit ;
:noname [ is poststep ]   eachlist> 20 collide-objects-map ;

interact off  \ start without IDE visible
