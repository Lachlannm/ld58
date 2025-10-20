function get_force_for_speed(obj_ref, speed_in_meters_per_second){
    return speed_in_meters_per_second * obj_ref.phy_linear_damping * obj_ref.phy_mass
}