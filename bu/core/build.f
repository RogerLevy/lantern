\ build tool - swiftforth/windows
\ build & deploy
\  delete/copy the template directory to debug and normal destinations
\ build only:
\  create commandline, debug, and "normal" exe's
\ deploy only:
\  create normal exe and execute

bu: idiom build:
import mo/cellstack

private:
    get-order  dup cellstack Order  set-order
public:
: save-order  get-order s>p Order swap pushes ;
: recall-order  order @length -exit  Order dup @length >r r@ pops  r> 1i set-order ;
variable 'boot
create buildname  256 allot
private:
    : system  ( cr 2dup type ) zstring >process-wait ;

    : copy-template  ( dest c -- )
        " rmdir /S /Q " 2over strjoin                      system  #200 ms
        " xcopy build-template /E /Y /S /I " 2swap strjoin system  #200 ms
    ;

    : releasedir  " builds\" buildname count strjoin ;
    : debugdir    " builds\" buildname count strjoin " _debug" strjoin ;

    : (boot)  recall-order   'boot @ execute  ;
    : gui      #0 'main cell+ !  ;
    : console  #-1 'main cell+ ! ;
    : cmdline-starter  recall-order  interactive ;
    : debug-starter  R0 @ RP!  +display  (boot)  ok  interactive ;
    : release-main   R0 @ RP!  +display  (boot)  begin  ok  again ;

public:
: build  ( -- <projectpath> <buildname> <starter-word> )
    save-order
    pushpath cd
    -display  false to allegro?
    bl parse buildname place
    starter  'starter @ 'boot !
    releasedir copy-template  debugdir copy-template

    ['] release-main 'main !  gui
    " program " s[ releasedir +s " \" +s  buildname count +s ]s evaluate
    " program " s[ debugdir   +s " \" +s  buildname count +s ]s evaluate

    ['] development 'main !  ['] debug-starter 'starter !  gui
    " program " s[ debugdir   +s " \" +s  buildname count +s  " _debug" +s   ]s evaluate

    ['] development 'main !  ['] cmdline-starter 'starter !  gui
    " program " s[ debugdir   +s " \" +s  buildname count +s  " _cmdline" +s ]s evaluate
    poppath ;
