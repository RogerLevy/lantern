\ Development environment loader
empty

defined dev 0<> nip not [if]
    include bu/core/preamble         \ base dependencies, incl. Allegro, loaded once per session
    include bu/dev/ld   including -name workdir place
    true constant dev
    s" envconfig.f" file-exists [if]
        include envconfig.f
    [then]
    : /autoexec  " ld " s[  workdir count +s  " \autoexec" +s  ]s evaluate ;
    gild
[then]

[defined] NO_IDE [if]
    include bu/core/core.f ide
    /autoexec
[else]
\    include bu/dev/ide.f ide
[then]
