switch(irandom(2))
{
	case 0:
		sprite_index = spr_yellow_car_sideways; break;
	case 1:
		sprite_index = spr_blue_car_sideways; break;
	case 2:
		sprite_index = spr_red_car_sideways; break;
}

max_speed = 5

reverse_direction = (forward_direction - 180) % 360;

enum CarState
{
	Idle_Origin,
	Advancing,
	Idle_Advanced,
	Retreating
}

car_state = CarState.Idle_Origin

alarm_min = 60
alarm_max = 120
alarm_moving_time = 20
alarm[0] = irandom_range(alarm_min, alarm_max)