bu: idiom shader:
private:
    0 value s
public:
: ?shader-error  0= if  s al_get_shader_log zcount alert cr quit  then ;
: attach-shader-file  ( shader shader-type path c -- )
    zstring al_attach_shader_source_file ?shader-error ;
: init-shader  ( shader path c -- )  \ pixel shader is loaded if it exists. (___.pixel.glsl)
    rot to s
    ( path c ) s[ ]s 2>r
    s ALLEGRO_VERTEX_SHADER 2r@ attach-shader-file
    " .pixel.glsl" 2r@ " .vertex.glsl" replace 2dup file-exists if
        s ALLEGRO_PIXEL_SHADER 2r@ attach-shader-file
    then
    2r> 2drop
    s al_build_shader ?shader-error
;
: shader  ( -- <name> <vertex-shader-path> )  ( -- shader )  \ pixel shader is loaded if it exists. (___.pixel.glsl)
    create ALLEGRO_SHADER_GLSL al_create_shader dup , bl parse init-shader
    does> @ ;
: /shader  ( shader-body path c -- )
    rot ALLEGRO_SHADER_GLSL al_create_shader dup >r swap !
    r> -rot init-shader ;
