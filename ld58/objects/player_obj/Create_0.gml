gas_rate = 0.015
gas_amount = 0
gas_strength = 0.06

brake_rate = 0.02
brake_amount = 0
brake_strength = 0.03

move_speed = 0
max_speed = 12

turn_speed = 0.1
turn_amount = 0
turn_rate = 0.02
max_turn_amount = 35

move_drag = gas_strength/max_speed
drag = 0.01

drift_amount = 0
drift_rate = 0.2
is_drifting = false

var test1 = move_toward(5, 10, 4)	 // Returns 9
var test2 = move_toward(10, 5, 4)    // Returns 6
var test3 = move_toward(5, 10, 9)    // Returns 10
var test4 = move_toward(10, 5, -1.5) // Returns 11.5