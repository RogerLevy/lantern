: perform> ( n -- <code> )
    ds 7 cells + !
    ds 6 cells + sp !
    r> rs 7 cells + !
    rs 7 cells + rp !
;

: perform  ( xt n actor -- )
    me >r be
    ds 7 cells + !
    ds 6 cells + sp !
    >code rs 7 cells + !
    rs 7 cells + rp !
    r> be
;


\ important: this word must not CALL anything or use the return stack until the bottom part.
: yield
    \ save state
    dup \ ensure TOS is on stack
    sp@ sp !
    rp@ rp !
    \ look for next task/actor.  rp=0 means no task.  end of list = jump to main task and resume that
    begin  me next @ be  me if  rp @  else  main be  true  then  until
    \ restore state
    rp @ rp!
    sp @ sp!
    drop \ ensure TOS is in TOS register
;


: end  0 rp! yield ;

: frames  0 do yield loop ;

: secs  60 * frames ;

: multi
    me >r
    dup
    stage first @ main next !
    sp@ main 's sp !
    rp@ main 's rp !
    main be
    ['] yield catch
    ?dup if
        main as
        rp @ rp!
        sp @ sp!
        drop
        throw
    then
    drop
    r> be
;

\ : :proc  actor single :noname 'act ! ;
\ : :task  actor single :noname 0 me perform ;
