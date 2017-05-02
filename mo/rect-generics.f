: rect.  dup @xy 2. rot @wh 2. ;
: @xywh  dup @xy rot @wh ;             : !xywh >r r@ !wh r> !xy ;
: @x2   dup @x swap @w + ;             : !x2   >r r@ @x - r> !w ;
: @y2   dup @y swap @h + ;             : !y2   >r r@ @y - r> !h ;
: @xy2  dup 2v@ rot @wh 2+ ;           : !xy2  >r r@ @xy 2- r> !wh ;
