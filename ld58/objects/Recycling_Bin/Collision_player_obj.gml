if !broken
{
    if alarm_get(0) == -1
    {
        alarm_set(0, 100)
    }
	broken = true
	other.take_damage(1)
}