switch(car_state)
{
	case CarState.Idle_Origin:
		speed = max_speed
		direction = forward_direction
		car_state = CarState.Advancing
		alarm[0] = alarm_moving_time
		break
	case CarState.Advancing:
		speed = 0
		car_state = CarState.Idle_Advanced
		alarm[0] = irandom_range(alarm_min_road, alarm_max_road)
		break
	case CarState.Idle_Advanced:
		speed = max_speed
		direction = reverse_direction
		car_state = CarState.Retreating
		alarm[0] = alarm_moving_time
		break
	case CarState.Retreating:
		speed = 0
		car_state = CarState.Idle_Origin
		alarm[0] = irandom_range(alarm_min_parking, alarm_max_parking)
		break
}