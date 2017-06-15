\ Multitasking for game objects

\ The following words should only be used within a task:
\  YIELD END FRAMES SECS
\ The following words should never be used within a task:
\  - External calls
\  - Console output (when the Bubble IDE is not loaded)
\  - EXIT or ; from the "root" of a task (the definition containing PERFORM> )

obj:
var sp  var rp  8 cells field ds  16 cells field rs  used @ to parms
used @ to parms
objects one named main  \ proxy for the Forth data and return stacks

: perform> ( n -- <code> )
    ds 7 cells + !
    ds 6 cells + sp !
    r> rs 7 cells + !
    rs 7 cells + rp !
;

: perform  ( xt n actor -- )
    { me!
    ds 7 cells + !
    ds 6 cells + sp !
    >code rs 7 cells + !
    rs 7 cells + rp !
    }
;

\ important: this word must not CALL anything or use the return stack until the bottom part.
: yield
    \ save state
    dup \ ensure TOS is on stack
    sp@ sp !
    rp@ rp !
    \ look for next task/actor.  rp=0 means no task.  end of list = jump to main task and resume that
    begin  me next @ me!  me if  rp @  else  main me!  true  then  until
    \ restore state
    rp @ rp!
    sp @ sp!
    drop \ ensure TOS is in TOS register
;

: end  0 rp! yield ;
: yields  0 do yield loop ;
: secs  fps * yields ;  \ not meant for precision timing

: multi  ( container -- )
    me >r
    first @ main next !
    dup
    sp@ main 's sp !
    rp@ main 's rp !
    main me!
    ['] yield catch
    ?dup if
        main me!
        rp @ rp!
        sp @ sp!
        drop
        throw
    then
    drop
    r> me!
;

