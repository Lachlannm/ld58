draw_text(x, y-32,"Current Level: " + string(global.upgrade_capacity.level))
if global.upgrade_capacity.level < 3
{
	draw_text(x, y, "Upgrade Cost " + string(global.upgrade_capacity.cost))
}
else
{
	draw_text(x, y, "Fully Upgraded")
}