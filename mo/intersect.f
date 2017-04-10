bu: idiom intersect:

: intersect?  ( line-xyxy line-xyxy - flag ) \ line-to-line
  locals| ry2 rx2 ry1 rx1 ly2 lx2 ly1 lx1 |
  lX1  lX2 -  rY1  rY2 -  *
  rX1  rX2 -  lY1  lY2 -  *  -  0<> ;
  \  (X1-X2)*(Y3-Y4) - (Y1-Y2)*(X3-X4)

: intersectBox?  ( line-xyxy rect-xyxy - flag )
  locals| ry2 rx2 ry1 rx1 ly2 lx2 ly1 lx1 |
  \ (these checks probably don't save much CPU, so i've commented them out)
  \ first check if the line is totally outside the box
  \ lx1 ly1 lx2 ly2 rx1 ry1 rx2 ry2 overlap? dup -exit drop
  \ then check if either the start or end of the line is in the box
  \ lx1 ly1 2dup rx1 ry1 rx2 ry2 overlap? dup ?exit drop
  \ lx2 ly2 2dup rx1 ry1 rx2 ry2 overlap? dup ?exit drop
  \ then check if the line intersects with any of the 4 sides
  lx1 ly1 lx2 ly2 rx1 ry1 rx1 ry2 intersect? dup ?exit drop
  lx1 ly1 lx2 ly2 rx1 ry1 rx2 ry1 intersect? dup ?exit drop
  lx1 ly1 lx2 ly2 rx2 ry1 rx2 ry2 intersect? dup ?exit drop
  lx1 ly1 lx2 ly2 rx1 ry2 rx2 ry2 intersect? ;

\\

\ this is more advanced than INTERSECT? ... this gets the point of intersection too.
	intersectLine: function (x1, y1, x2, y2, x3, y3, x4, y4) {
		var s1_x, s1_y, s2_x, s2_y;
		s1_x = x2 - x1; s1_y = y2 - y1;
		s2_x = x4 - x3; s2_y = y4 - y3;

		var s, t;
		s = (-s1_y * (x1 - x3) + s1_x * (y1 - y3)) / (-s2_x * s1_y + s1_x * s2_y);
		t = ( s2_x * (y1 - y3) - s2_y * (x1 - x3)) / (-s2_x * s1_y + s1_x * s2_y);

		if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
		{
			// Collision detected
			var atX = x1 + (t * s1_x);
			var atY = y1 + (t * s1_y);
			return { x: atX, y: atY };
		}

		return false; // No collision
	}
