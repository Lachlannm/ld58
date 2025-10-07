draw_text(x, y-32,"Current Level: " + string(global.upgrade_turn_radius.level))
if global.upgrade_turn_radius.level < 3
{
	draw_text(x, y, "Upgrade Cost " + string(global.upgrade_turn_radius.cost*(global.upgrade_turn_radius.level+1)))
}
else
{
	draw_text(x, y, "Fully Upgraded")
}