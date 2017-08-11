empty
include le/le

image cat.image le/om/macak04.png

le: role cat:
    include le/om/spr
    : center  imagewh 0.5 0.5 2* orgx 2! ;
    : cat  sprite  cat.image center  draw>  cat.image bmp @ sprite  0.01 ang +! ;
    displaywh 0.5 0.5 2* at  one cat  me value cat  2 2 sx 2!
