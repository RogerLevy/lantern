\ various words.  intended to be gleened a la carte.

: smudge  ( - <word> )  \ disable a word from being searchable in the dictionary.
  defined if  >name 1 erase  else  drop  then ;

: ext  [char] . scan #1 /string ;

: count+  dup  count u+ #2 u+  #1 - count ;
