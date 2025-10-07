if phy_speed > 0 and alarm_get(0) == -1
{
    alarm_set(0, 100)
}