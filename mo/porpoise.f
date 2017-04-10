\ OOP for Bubble by Roger Levy

\ classes support rudimentary static vars.  static var values are inherited.
\  to add and assign static vars,
\    <superclass> INHERIT
\      xvar foo  123 p foo !  \ init prototype the short way
\      STATICVAR <name>
\    SUBCLASS <name>
\    STATICVAR <name>         \ you don't have to declare static vars inside the class definition
\    <value> class <static var> !
\    <value> class proto @ <field> !  \ init prototype the long way
\    XMESSAGE <name>  ( [stuff] -- [stuff] )         \ works similar to STATICVAR, make sure to document the stack effect.
\    <class> :M  ( [stuff] -- [stuff] )  ... ;       \ program a class's response to a message.

bu: idiom porp:

cell  xvar sizeof  xvar super  xvar proto  struct /class
$C7A5533 constant CLASS_MAGIC

: copy,  ( src #count -- ) here swap dup allot move ;

\ --------------------------------------------------------------------------------------------------
\ Class definition
: staticvar  ( -- <name> )  /class xvar to /class ;

staticvar on-subclass ( class -- )
staticvar on-inherit  ( superclass -- )

wordlist constant classing
classing +order definitions
    create p  1024 cells allot

porp:

classing +order
: subclass   ( super sizeof -- <name> )
    here locals| newproto newsize super |
    newsize /allot
    p  newproto  super sizeof @  move
    super newproto ( class ) !  newsize newproto cell+ ( size ) !
    create  here >r  CLASS_MAGIC ,  newsize ,  super ,  newproto ,
    super 4 cells +  /class 4 cells - copy,
    r> ( class ) dup on-subclass @ execute
    classing -order ;
: extend  subclass ;  \ improve this?
\ the `p` buffer can be used to initialize fields while declaring them.
: inherit  ( class -- super sizeof )
    dup proto @  over sizeof @  p swap  move
    dup sizeof @  classing +order
    over dup on-inherit @ execute ;
classing -order

\ --------------------------------------------------------------------------------------------------
\ Root "object" class

create object-proto
    0 , 2 cells ,

0  xvar class  xvar size
    create object
    CLASS_MAGIC ,  ( 2 cells ) ,  0 , object-proto ,  ' drop ( 'on-subclass ) , ' drop ( 'on-inherit ) ,
    95 cells /allot

object object-proto !  \ initialize prototype class


\ --------------------------------------------------------------------------------------------------
\ Messages

: xmessage  ( -- <name> )  ( ... object -- ... )
    create  /class ,  cell +to /class  does>  @ over class @ + @ execute ;
: :m  ( class -- <xmessage> )
    >r  :noname  ' >body @  r> +  ! ;


\ --------------------------------------------------------------------------------------------------
\ Object instantiation
: instance,   ( class -- )  dup proto @ swap sizeof @ copy, ;
\ : class!     ( class dest -- )  >r dup sizeof @ r@ size ! r> class ! ;
: instance!  ( class dest -- )  >r dup proto @ r> swap sizeof @ move ;
\ : instance   ( class -- <name> )  create instance, ;

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
