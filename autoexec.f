\ include stranger/stranger.f [stranger]
cr
cr .( Directory: )
cr

: project
    create cr  last @ count type  space space space  0 parse 2dup type
            string,
    does> count rld$ place  rld$ count included ;

project dumbtest ex/dumbtest/main
\ project race relayrace/main
project arnie arnie/dev
