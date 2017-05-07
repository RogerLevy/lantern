\ software paletted graphics, version 1
\  8-bit 128-byte-pitch graphics format, but the palette is a maximum of 4 colors (3 if transparency is used)
bu: idiom spg:
import mo/pen
import mo/draw
include temp/kb

decimal \ pretty much the whole file is in decimal mode.
private:
    ALLEGRO_PIXEL_FORMAT_ARGB_8888 constant format
    create pal 0 , 0 , 0 , 0 ,
    0 value b     \ the bitmap
    0 value r     \ the locked bitmap region
    0 value buf   \ the start of the buffer given by the region
    0 value pxl   \ pointer to pixel in locked bitmap
    0 value pitch \ pitch of the locked bitmap
    create penx 0 , here 0 , constant peny  \ note this pen uses integers.
    : at  2dup penx 2v!    pitch * swap     cells + buf + to pxl ;
    : +at  2dup penx 2v+!  pitch * +to pxl  cells  +to pxl ;
    : +x  dup penx +!    cells +to pxl ;
    : x+  1 penx +!  cell +to pxl ;
    : +y  dup peny +!  pitch * +to pxl ;
    : y+  1 peny +!  pitch +to pxl ;
public:
\ optimization opportunity: if we can eliminate the per-pixel clipping code, we can probably shave 30-40% off of GARBAGE
: dot    ( adr -- adr )  penx @ dup 0 >= swap 256 < and -exit  dup c@ cells pal + @ pxl ! ;
: ?dot    ( adr -- adr ) penx @ dup 0 >= swap 256 < and -exit  dup c@ ?dup -exit  cells pal + @ pxl ! ;
: drawing  ( -- )
    r ?exit
    b  format  ALLEGRO_LOCK_WRITEONLY
        al_lock_bitmap to r
    r ALLEGRO_LOCKED_REGION-data @ to buf
    r ALLEGRO_LOCKED_REGION-pitch @ to pitch
    0 0 at ;
: present  ( -- )
    0 to r  b al_unlock_bitmap  0 0 0 clear-to-color  b 2.0 udraw
    drawing ;
: /spg  ( -- )
    ALLEGRO_VIDEO_BITMAP al_set_new_bitmap_flags
    format al_set_new_bitmap_format
    256 256 al_create_bitmap to b
    drawing ;

private:
    : ?early  ( adr -- adr |  )
        penx @ -7 >= if
            penx @ 256 < if
                peny @ -7 >= if
                    peny @ 240 < ?exit
                then
            then
        then
        r> drop  drop  8 +x ;

    variable 'dot  \ DEFER (as SwiftForth implements it) is REALLY slow!!!!!!!!!!!!
    : (dot)  " 'dot @ call" evaluate ; immediate

    : vclip  ( adr #rows -- adr #rows )
        peny @ 0<
        if  peny @ dup 128 * negate swap 2+  penx @ 0 at
        else  peny @ 233 >= if peny @ 232 - -  then
        then ;

    : vclip<  ( adr #rows -- adr #rows )  \ for vflip
        peny @ 0<
        if  peny @ dup 128 * swap 2+  penx @ 0 at
        else  peny @ 233 >= if peny @ 232 - -  then
        then ;

public:
: transparent  ['] ?dot >code 'dot ! ;  transparent
: opaque       ['] dot >code 'dot ! ;


\ all "lay" routines leave the pen 8 pixels to the right from when they were called.
: lay ( adr -- )  \ draws an 8x8 tile.  assumes source pitch is 128 bytes.
    ?early
    penx 2v@ 2>r  8  vclip
    0 do  \ further unrolling has no effect.
        (dot)  1 +  x+
        (dot)  1 +  x+
        (dot)  1 +  x+
        (dot)  1 +  x+
        (dot)  1 +  x+
        (dot)  1 +  x+
        (dot)  1 +  x+
        (dot)
        121 +  -7 +x  y+
    loop  drop
    2r> 8 u+ at ;

: layh ( adr -- )  \ draws an 8x8 tile.  assumes source pitch is 128 bytes.
    ?early
    penx 2v@ 2>r  7 +  8  vclip
    0 do  \ further unrolling has no effect.
        (dot)  1 -  x+
        (dot)  1 -  x+
        (dot)  1 -  x+
        (dot)  1 -  x+
        (dot)  1 -  x+
        (dot)  1 -  x+
        (dot)  1 -  x+
        (dot)
        135 +  -7 +x  y+
    loop  drop
    2r> 8 u+ at ;

: layv ( adr -- )  \ draws an 8x8 tile.  assumes source pitch is 128 bytes.
    ?early
    penx 2v@ 2>r  [ 7 128 * ]# +  8  vclip<
    0 do  \ further unrolling has no effect.
        (dot)  1 +  x+
        (dot)  1 +  x+
        (dot)  1 +  x+
        (dot)  1 +  x+
        (dot)  1 +  x+
        (dot)  1 +  x+
        (dot)  1 +  x+
        (dot)
        135 -  -7 +x  y+
    loop  drop
    2r> 8 u+ at ;

: layhv ( adr -- )  \ draws an 8x8 tile.  assumes source pitch is 128 bytes.
    ?early
    penx 2v@ 2>r  [ 7 128 * ]# + 7 +   8  vclip<
    0 do  \ further unrolling has no effect.
        (dot)  1 -  x+
        (dot)  1 -  x+
        (dot)  1 -  x+
        (dot)  1 -  x+
        (dot)  1 -  x+
        (dot)  1 -  x+
        (dot)  1 -  x+
        (dot)
        121 -  -7 +x  y+
    loop  drop
    2r> 8 u+ at ;

: !pal  ( adr -- )  pal 4 cells move ;
: clear  ( -- )  drawing  buf 256 240 * cells erase ;
: >tile  ( adr #n -- adr )  dup 4 rshift 10 lshift swap 15 and 3 lshift + + ;

\ more stuff:
\  [ ] drawing simple macros, with flip support (max 128 width)
\  [ ] drawing simple macros, with flip support (arbitrary width, does not care about the source pitch)
\  [ ] drawing tilemaps, with flip and multiple palette support
\  [ ] painting: convert address,x,y in image space to address,x,y in tile space

\ --------------------------------------------------------------------------------------------------
\ Test

[defined] dev [if]
    create testpal
        0 , $FFFF0000 , $FF0000FF , $FF00FF00 ,
        0 , $FF404040 , $FF808080 , $FFFFFFFF ,
        0 , $FF802000 , $FFFF8000 , $FFFFFF00 ,
        0 , $FFFF00FF , $FF808000 , $FF00FFFF ,

    " temp/chr000.raw"
    create vrom file,

\        $00 c, $00 c, $01 c, $01 c, $01 c, $01 c, $00 c, $00 c,  128 8 - allot
\        $00 c, $01 c, $02 c, $02 c, $02 c, $02 c, $01 c, $00 c,  128 8 - allot
\        $01 c, $02 c, $00 c, $03 c, $03 c, $00 c, $02 c, $01 c,  128 8 - allot
\        $01 c, $02 c, $03 c, $03 c, $03 c, $03 c, $02 c, $01 c,  128 8 - allot
\        $01 c, $02 c, $03 c, $03 c, $03 c, $03 c, $02 c, $01 c,  128 8 - allot
\        $01 c, $02 c, $00 c, $00 c, $00 c, $00 c, $02 c, $01 c,  128 8 - allot
\        $01 c, $02 c, $02 c, $02 c, $02 c, $02 c, $02 c, $01 c,  128 8 - allot
\        $01 c, $01 c, $01 c, $01 c, $01 c, $01 c, $01 c, $01 c,  128 8 - allot

    \ --------------------------------------------------------------------------------------------
    fixed
    /spg
    testpal !pal
    create lays  ' lay , ' layh , ' layv , ' layhv ,
    : layf  ( adr flip -- )  cells lays + @ execute ;

    variable x  variable y
    : garbage
        x @ y @ 2i at
        30 0 do
            32 0 do
                \ #4 rnd s>p 4 cells * testpal + !pal  vrom #7 >tile  lay \ 4 rnd layf
                #4 rnd s>p 4 cells * testpal + !pal  vrom #64 rnd >tile  4 rnd layf
            loop
            #-256 #8  +at
        loop ;

    : at  2i at ;
    : +at  2i +at ;


    : test
        go>
        render> clear garbage present
        step>
            pollkb
            <left> kstate if x -- then
            <right> kstate if x ++ then
            <up> kstate if y -- then
            <down> kstate if y ++ then
            ;

    garbage test ok
[then]
