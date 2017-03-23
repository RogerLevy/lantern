
\ nts: idea: DEFER what we run here to do different things at the prompt
\  than at runtime.  such as a separate "scene" for testing.

: (game-prompt)
  .stack
  state @ 0= if
    display if
      -ide  ['] (render) catch drop  ide
    then
    ."  ok"
  then  cr ;

' prompt >body @ constant (prompt)
:prune  ?prune if  (prompt) is prompt  cr ." restored old prompt"  then ;

: gamedev  ['] (game-prompt) is prompt ;
: quit     (prompt) is prompt  quit ;

gamedev
