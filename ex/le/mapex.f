empty
include le/le
le: idiom mapex:
    import le/mo/loadtmx

" ex/le/lk/test.tmx" opentmx
load-tiles
0 layer[]  0 0 tilemap addr  2048 cells  extract   \ extract tilemap.  we assume layer 0 exists.
scene  0 objgroup[]  load-objects
