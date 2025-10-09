draw_text(x, y-32,"Current Level: " + string(global.upgrade_acceleration.level))
if global.upgrade_acceleration.level < 3
{
	draw_text(x, y, "Upgrade Cost " + string(global.upgrade_acceleration.cost))
}
else
{
	draw_text(x, y, "Fully Upgraded")
}