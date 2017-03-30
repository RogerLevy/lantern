[bu] idiom [portion]
import mo/cellstack

[undefined] /portion [if] 64 cells constant /portion [then]
[undefined] /heap [if] 1 megs constant /heap [then]
/heap /portion / constant #portions
create heap /heap /allot
#portions cellstack free-portions
: reset-portions  free-portions vacate  heap  #portions 0 do  dup free-portions push  /portion +  loop  drop ;
: portion  ( -- adr )  free-portions pop ;
: free  ( adr -- )  free-portions push ;
reset-portions
