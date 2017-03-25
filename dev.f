\ Development environment loader
empty

include bu/core/preamble         \ base dependencies, incl. Allegro, loaded once per session
true constant dev
gild

s" envconfig.f" file-exists [if]
    include envconfig.f
    gild
[then]

[defined] NO_IDE [if]
    include bu/core/core.f ide
    include autoexec.f
[else]
    include bu/dev/ide.f ide
[then]
