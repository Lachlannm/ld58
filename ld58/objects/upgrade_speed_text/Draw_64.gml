draw_text(x, y-32,"Current Level: " + string(global.upgrade_speed.level))
if global.upgrade_speed.level < 3
{
	draw_text(x, y, "Upgrade Cost " + string(global.upgrade_speed.cost))
}
else
{
	draw_text(x, y, "Fully Upgraded")
}