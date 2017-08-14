role kevin:
    import le/oe/task
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
    var stamina
    var jumppower
    var risepower

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
       stamina @ 0 <= if die then ;

    : drift   vx @ 0.90 * vx !   ;
    : movelegs   ( n. - )  abs 6.0 /  anmspd ! ;
    : ?walk.anm   @playing walk.anm <> if  walk.anm 1 animate  then ;

    : to-a-stop
       drift
       vx @ abs dup 0.2 <
       if   drop   0 vx !   idle.anm 0 animate
       else ?walk.anm movelegs then ;

    : walkAccelR   vx @ 0.14 + walkSpeed @ min dup vx ! movelegs ;
    : walkAccelL   vx @ -0.14 + walkSpeed @ negate max dup vx ! movelegs ;

    : ctrl  act>  0 0 vx 2v!  2 vx udlr ;

    : draw-kevin  @anm+ img @ afsubimg  at@ 2af  flip@  al_draw_bitmap_region ;

    : animthru   animate  begin  pause  end-of-anm? until ;

    :is jump
       0 perform>   jump.anm 1 animate   jumppower @ negate dup vy !   y +!
       risepower @ negate
       begin   vy @ 0<  <jump> kstate  and
       while   dup vy +!  control-in-air   pause   repeat
       fall ;


public:

: kevin  ctrl  idle.anm 1 animate draw>  draw-kevin ;


    \\



    on: squat
       b perform>   0 vx !   1 speed   squat.anm a animthru
       ducking.anm 1 animate
       begin pause <squat> kstate not until
       1.0 a speed stand.anm a animthru   idle ;


    on: walkl
       b perform> faceleft walk.anm a animate
       begin <left> kstate while  walkAccelL can-squat can-jump can-die   pause  repeat
       idle ;

    on: walkr
       b perform> faceright walk.anm a animate
       begin <right> kstate while  walkAccelR can-squat can-jump can-die   pause   repeat
       idle ;

    on: idle
       b perform> ?walk.anm
       begin  to-a-stop  can-walk  can-squat  can-die  can-jump  pause   again ;

    on: fall
       b perform>  jump.anm a animate   begin  control-in-air   pause  again ;

    on: land
       idle ;

    on: react
       b promote ;

    : revive   100 stamina ! idle ;

    on: die
       b perform>  ( *die* ) 0 vx !   0.1 a speed   die.anm a animthru   die.b.anm a animate   100 pauses   revive ;

    on: start   faceright idle ;

    i: added
       5 3 10 17 *hitbox ;

