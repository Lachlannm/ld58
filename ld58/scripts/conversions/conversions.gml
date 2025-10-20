function pixels_to_meters(pixel_based_value){
    return pixel_based_value * room_get_info(room).physicsPixToMeters
}

function meters_to_pixels(meter_based_value){
    return meter_based_value / room_get_info(room).physicsPixToMeters
}

function m_per_second_to_km_per_hour(mps)
{
    return mps * 3.6
}

function km_per_hour_to_m_per_second(kph)
{
    return kph / 3.6
}