bu: idiom dirtools:
[defined] linux [if]
[else]
    : create-directory   zstring 0 CreateDirectory 0= if GetLastError ERROR_PATH_NOT_FOUND = abort" Path not found." then ;
    : chdir  ( adr c -- )
        OVER C@ [CHAR] " = IF  NEGATE >IN +! DROP
        [CHAR] " WORD COUNT  THEN  +ROOT  OVER + 0 SWAP C!
        SetCurrentDirectory 0= ABORT" Invalid Directory" ;
[then]
