var dir = point_direction(x,y,other.x,other.y)
var colliding = true

while colliding
{
	other.x += lengthdir_x(0.1,dir)
	other.y += lengthdir_y(0.1,dir)
	colliding = place_meeting(x,y,other)
}