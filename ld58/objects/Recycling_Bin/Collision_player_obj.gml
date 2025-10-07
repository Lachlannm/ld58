if !broken
{
	sprite_index = spr_destroyed_recycling_bin
	broken = true
	other.take_damage(1)
	instance_destroy()
}