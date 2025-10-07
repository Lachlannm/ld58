function project_vector(a_x, a_y, b_x, b_y){
    var a_dot_b = dot_product(a_x, a_y, b_x, b_y)
    var mag_b = point_distance(0, 0, b_x, b_y)
    var scale_factor = (a_dot_b / mag_b)
    return [scale_factor * b_x, scale_factor * b_y]
}