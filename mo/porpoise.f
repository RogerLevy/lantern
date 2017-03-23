\ OOP for Bubble by Roger Levy

\ classes support rudimentary static vars.  static var values are inherited.
\  to add and assign static vars,
\    <superclass> INHERIT
\      ...
\      STATICVAR <name>
\      ...
\    CLASS <name>
\    ...
\    <value> class <static var> !

[bu] idiom [porp] _public

cell  xvar sizeof  xvar super  xvar proto  struct /class
$C7A5533 constant CLASS_MAGIC

: copy,  ( src #count -- ) here swap dup allot move ;

\ --------------------------------------------------------------------------------------------------
\ Class definition
: staticvar  ( -- <name> )  /class xvar to /class ;

wordlist constant classing
classing +order definitions
    create p #1024 allot
    : class   ( super sizeof -- <name> )
        here locals| newproto newsize super |
        newsize /allot
        p newproto super sizeof @ move
        super p ( class ) !  newsize p cell+ ( size ) !
        create  CLASS_MAGIC ,  newsize ,  super ,  newproto ,
        super /class + 100 cells copy,
        classing -order ;
    : extend  class ;  \ interim definition ?
previous definitions

: inherit  dup sizeof @  classing +order ;        ( class -- super sizeof )

\ --------------------------------------------------------------------------------------------------
\ Root "object" class

0  xvar class  xvar size
create object  CLASS_MAGIC , ( sizeof ) , 0 , 100 cells /allot

\ --------------------------------------------------------------------------------------------------
\ Messages

: xmessage  create /class , cell +to /class  does>  @ over class @ + @ execute ;

\ --------------------------------------------------------------------------------------------------
\ Object instantiation
: instance   ( class -- )  dup proto @ here rot sizeof @ copy, ;
: instance!  ( class dest -- )  >r dup proto @ r> swap sizeof @ move ;

\ growable objects - not sure if useful?  3/18
\ wordlist constant instancing
\ instancing +order definitions
\     : ,      ( object n -- )  , cell over size +! ;
\     : allot  ( object #count -- )  dup allot over size +! ;
\     : /allot  ( object #count -- )  dup /allot over size +! ;
\     : string,  ( object addr #c -- )  here >r  string,  here r> - over size +! ;
\ previous definitions
\ : [i  ( object -- object ) instancing +order
\ : i]  ( object -- )  drop  instancing -order ;
