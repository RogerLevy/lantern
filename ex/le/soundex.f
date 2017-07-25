empty
include le/le
include le/oe/task

\ sfx *test* ex/le/asdf.ogg
\ *test*
" ex/le/asdf.ogg" play
cr ." Streaming audio for 5 seconds .... "


: (stop)  later> stop ;
: do-it  objects one 0 perform> 5 secs  bgm  ['] stop later  end ;


do-it
