[swes] idiom [sprites]
import mo/pen

/image safetable spritesets

: spriteset  ( w h image -- <name> )  ( -- id )
    spritesets entry >r  r@ /image move  r> subdivide ;

\ Utility to help with calling Allegro functions.
: sprite>af  ( subimage# spriteset# -- bitmap afsx afsy afsw afsh )
    spritesets id> afsubimg ;

: #sprites  ( spriteset# -- n )
    spritesets id> numSubimages @ ;

\ : spriteSize  ( spriteset# -- w h )
\    spritesets id> subw 2v@ ;


\ ------------------------------------------------------------------------------------------------
\ Stock drawing words. Anything more complicated than this isn't helpful.
: drawSpriteFlip  ( subimage# spriteset# flip -- )
    >r  sprite>af  at@ 2af  r>  al_draw_bitmap_region ;

: drawSprite  ( subimage# spriteset# -- )
    0 drawSpriteFlip ;
\ ------------------------------------------------------------------------------------------------
