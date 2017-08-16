empty
include le/le
import le/oe/task

sfx *link* ex/le/link.wav

: nextpart
    cr ." Streaming an Impulse Tracker module..."
    " ex/le/mountain.xm" play ;

: task  one ;

: do-this  task 0 perform>  5 secs  0 ['] nextpart later ;
: do-that  task 0 perform>  begin  0 ['] *link* later  1 secs  again ;

" ex/le/asdf.ogg" play

cr .( Streaming ogg audio for 5 seconds and playing a sound effect once a second...)
do-this do-that
