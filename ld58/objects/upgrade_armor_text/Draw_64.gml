draw_text(x, y-32,"Current Level: " + string(global.upgrade_armour.level))
if global.upgrade_armour.level < 3
{
	draw_text(x, y, "Upgrade Cost " + string(global.upgrade_armour.cost*(global.upgrade_armour.level+1)))
}
else
{
	draw_text(x, y, "Fully Upgraded")
}