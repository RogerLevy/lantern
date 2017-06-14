\ Development environment loader
empty

cr .( NOTICE: Audio and other addons will not work on Windows unless you copy all of the )
cr .( dependency DLL's to Swiftforth's bin folder. I tried everything and they just would not )
cr .( work from the lib\ folder. I'm guessing it's a security measure. This shouldn't affect )
cr .( released applications; so long as the DLL's are in the same folder as the turnkey executable,)
cr .( they should load.  You can still load the Allegro DLL without doing this; you just won't )
cr .( be able to play anything but WAV files.)

defined dev 0<> nip not [if]
    s" envconfig.f" file-exists [if]
        include envconfig.f
    [then]
    include bu/lib/preamble         \ base dependencies, incl. Allegro, loaded once per session
    include dev/ld
    true constant dev
    gild
[then]

pushpath
decimal
al_init
al_init_acodec_addon
al_install_audio
z" temp/asdf.ogg" al_load_sample
z" temp/mus_mode.ogg" al_load_sample
z" temp/palmroad.wav" al_load_sample constant palmroad

include bu/core/core.f  >ide
gild
ld dev/sf/ide2
\ go
