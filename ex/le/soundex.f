empty
include le/le
include le/oe/task

sfx *link* ex/le/link.wav

: nextpart
    drop  cr ." Streaming an Impulse Tracker module..."
    " ex/le/mountain.xm" play ;

: task  objects one ;

: do-this  task 0 perform> 5 secs  bgm  0 ['] nextpart later  end ;
: do-that  task 0 perform> begin  ['] *link* later0  1 secs  again ;

" ex/le/asdf.ogg" play
\ " ex/le/bgm006.it" play

cr .( Streaming ogg audio for 5 seconds and playing a sound effect once a second...)
do-this do-that
