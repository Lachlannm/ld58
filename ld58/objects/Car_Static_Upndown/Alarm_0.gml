switch(car_state)
{
	case 0:
		speed = max_speed
		direction = forward_direction
		car_state = 1
		alarm[0] = alarm_moving_time
		break
	case 1:
		speed = 0
		car_state = 2
		alarm[0] = irandom_range(alarm_min_road, alarm_max_road)
		break
	case 2:
		speed = max_speed
		direction = reverse_direction
		car_state = 3
		alarm[0] = alarm_moving_time
		break
	case 3:
		speed = 0
		car_state = 0
		alarm[0] = irandom_range(alarm_min_parking, alarm_max_parking)
		break
}