: flag  ( offset bitmask -- <name> offset bitmask<<1 )  ( -- bitmask adr )
    create dup , over , 1 <<
    does>  dup @ swap cell+ @ me + ;

: set?   @ and 0<> ;
: set    dup @ rot or swap ! ;
: unset  dup @ rot invert and swap ! ;
: xorset dup @ rot xor swap ! ;
