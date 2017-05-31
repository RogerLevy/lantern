\ Actor system - low level tools
le:

container instance stage0
stage0 value stage   \ just a container

\ Every game object and actor has its own private idiom.
\ These fields implicitly address based on the ME pointer.
\ To change the ME pointer in a scalable way, use [[ ]] (set and fetch ME) and 's (access a field)
\ The prompt is extended to display the current object's address and class.
0 value me
: [[  " to me" evaluate ;  immediate
: ]]  " me" evaluate ;  immediate
: be  " to me" evaluate ; immediate
: as>  r>  me >r  swap to me  call  r> to me ;
: 's  \ turns "smart" fields into xfields
  state @ if
    " me >r  to me " evaluate  bl parse evaluate  " r> to me" evaluate
  else
    " me swap to me " evaluate  bl parse evaluate  " swap to me" evaluate
  then
; immediate
[defined] dev [if]
: field  create over , + does> @ me + ;
[else]
: field  create over , + immediate does> @ " me ?lit + " evaluate ;  \ faster but less debuggable version
[then]
: var  cell field ;
: flag  ( offset bitmask -- <name> offset bitmask<<1 )  ( -- bitmask adr )
    create dup , over , 1 <<
    does>  dup @ swap cell+ @ me + ;
: set?   @ and 0<> ;
: set    dup @ rot or swap ! ;
: unset  dup @ rot invert and swap ! ;
: xorset dup @ rot xor swap ! ;

