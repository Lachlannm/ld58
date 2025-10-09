draw_text(x, y-32,"Current Level: " + string(global.upgrade_brakes.level))
if global.upgrade_brakes.level < 3
{
	draw_text(x, y, "Upgrade Cost " + string(global.upgrade_brakes.cost))
}
else
{
	draw_text(x, y, "Fully Upgraded")
}