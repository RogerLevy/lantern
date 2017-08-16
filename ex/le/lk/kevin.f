role kevin:
    import le/oe/task
    import le/oe/tiled

    \ mixins
    include le/om/flipbook

    image kevin.image ex/le/lk/chr_lk.png
    20 20 kevin.image subdivide

    \ typical stuff
    var dir    \ direction, see above enums
    var data   \ static NPC data, like animation pointers

    flipbook: idle.anm    kevin.image , 0  , ;
    flipbook: duck.anm    kevin.image , 10 , ;
    flipbook: blink.anm   kevin.image , 11 , 12 , ;
    flipbook: walk.anm    kevin.image , 29 , 30 , 31 , ;
    flipbook: jump.anm    kevin.image , 36 , ;

    create  dirs  FLIP_NONE , FLIP_NONE , FLIP_NONE , FLIP_H ,
    : flip@  dirs dir @ th @ ;

    \ script vars
    var walkspeed
    var jumppower
    var risepower
    var inair
    var falling

    <space> constant <jump>
    <down> constant <squat>

    defer walkl ' noop is walkl
    defer walkr ' noop is walkr
    defer jump  ' noop is jump
    defer squat ' noop is squat
    defer fall  ' noop is fall
    defer idle  ' noop is idle
    defer die   ' noop is die
    defer land  ' noop is land

    : in-air?  inair @ ;

    : faceleft  DIR_LEFT dir ! ;
    : faceright  DIR_RIGHT dir ! ;

    : can-jump   <jump> kpressed if jump then ;
    : can-walk   <left> kstate if walkL then   <right> kstate if walkR then ;
    : can-squat   <squat> kstate if squat then ;

    : control-in-air
       <left> kstate if  -0.2 vx +!  faceleft then
       <right> kstate if  0.2 vx +!  faceright then
       vx @ 0.95 *  walkspeed @ vx @ 0< if negate max else min then vx ! ;

    : can-die
    \   <enter> kstate if die then
    ; \    stamina @ 0 <= if die then ;

    : drift   vx @ 0.90 * vx !   ;
    : movelegs   ( n. - )  abs 5.0 swap -   anmspd ! ;
    : ?walk.anm   @playing walk.anm <> if  walk.anm 1 animate  then ;

    : to-a-stop
        drift
        vx @ abs 0.2 <
            if   0 vx !   idle.anm 0 animate
            else  ?walk.anm  vx @ movelegs  then ;

    : walkAccelR   vx @ 0.14 + walkSpeed @ min dup vx ! movelegs ;
    : walkAccelL   vx @ 0.14 - walkSpeed @ negate max dup vx ! movelegs ;

    : ctrl  idle.anm 1 animate  act>  0 0 vx 2v!  2 vx udlr ;

    : draw-kevin  @anm+ img @ afsubimg  at@ 2af  flip@  al_draw_bitmap_region ;

    : animthru   animate  begin  pause  end-of-anm? until ;

    :is jump
       0 perform>   jump.anm 1 animate   jumppower @ negate dup vy !   y +!
       risepower @ negate
       begin   vy @ 0<  <jump> kstate  and
       while   dup vy +!  control-in-air   pause   repeat
       fall ;

    :is walkl
       0 perform>  faceleft  walk.anm 1 animate
       begin <left> kstate while  walkAccelL can-squat can-jump can-die   pause  repeat
       idle ;

    :is walkr
       0 perform>  faceright  walk.anm 1 animate
       begin <right> kstate while  walkAccelR can-squat can-jump can-die   pause   repeat
       idle ;

    :is idle
        0 perform> ?walk.anm
        begin  to-a-stop  can-walk  can-squat  can-die  can-jump  pause   again ;

    : (fall)   inair on  falling @ not  vy @ 0 >= and  if  falling on  fall  then ;
    : (land)   falling off  land  inair off  ;
    : hitmap  floor? not if  (fall)  else  in-air? if  (land)  then  then ;

    :is fall  (fall)  0 perform>  jump.anm 1 animate   begin  control-in-air   pause  again ;
    :is land  idle ;

    : conf
        3 1 mbx 2v!
        14 19 mbw 2v!
        1.6 walkspeed !
        3 jumppower !
        0.1015 risepower !
        act>  0.15 vy +!  onhitmap> drop  hitmap ;

public:

: kevin  ( ctrl )  fall  conf  draw>  draw-kevin ;
