: ?bounds  vis# set? -exit  @bounds 2over 2- 2swap at  white rect ;

: monsters
    0 stage all>  ?show  ?bounds
;

: hud

;

: controls
    step>
;

: playfield  go>  controls  render>  0 0 0 clear-to-color  monsters  hud ;
