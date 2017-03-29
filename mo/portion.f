[bu] idiom [portion]
import mo/cellstack

#128 constant /portion
2 megs constant /heap
/heap /portion / constant #portions
create heap /heap allot
#portions cellstack free-portions
: reset-portions  free-portions vacate  heap  #portions 0 do  dup free-portions push  /portion +  loop  drop ;
: portion  ( -- adr )  free-portions pop ;
: free  ( adr -- )  free-portions push ;
reset-portions
