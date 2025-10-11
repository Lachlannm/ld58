function project_vector(a_x, a_y, b_x, b_y)
{
    var a_dot_b = dot_product(a_x, a_y, b_x, b_y)
    var mag_b = point_distance(0, 0, b_x, b_y)
    var scale_factor = (a_dot_b / (mag_b * mag_b))
    return [scale_factor * b_x, scale_factor * b_y]
}

function test_project_vector()
{
    var current_total_and_failed = [0,0]
    
    var zero = [0, 0]
    
    var up = [0, -1]
    var right = [1, 0]
    var down = [0, 1] 
    var left = [-1, 0]
    
    var up_right = [1, -1]
    var down_right = [1, 1]
    var up_left = [-1, -1]
    var down_left = [-1, 1]
    
    test_projection("up onto right", up, right, zero, current_total_and_failed)
    test_projection("up onto left", up, left, zero, current_total_and_failed)
    test_projection("down onto right", down, right, zero, current_total_and_failed)
    test_projection("down onto left", down, left, zero, current_total_and_failed)
    
    test_projection("right onto up", right, up, zero, current_total_and_failed)
    test_projection("right onto down", right, down, zero, current_total_and_failed)
    test_projection("left onto up", left, up, zero, current_total_and_failed)
    test_projection("left onto down", left, down, zero, current_total_and_failed)
    
    test_projection("up onto down", up, down, up, current_total_and_failed)
    test_projection("down onto up", down, up, down, current_total_and_failed)
    test_projection("left onto right", left, right, left, current_total_and_failed)
    test_projection("right onto left", right, left, right, current_total_and_failed)
    
    test_projection("up_right onto up", up_right, up, up, current_total_and_failed)
    test_projection("down_right onto up", down_right, up, down, current_total_and_failed)
    
    test_projection("up onto up_right", up, up_right, [0.5, -0.5], current_total_and_failed)
    test_projection("up onto up_right2", [0,-90], [-0.71, -0.71], [45, -45], current_total_and_failed)
    
    
    var total_tests_run = current_total_and_failed[0]
    var total_tests_failed = current_total_and_failed[1]
    
    if total_tests_failed > 0
    {
        show_debug_message("FAILED TESTS: {0} / {1}", total_tests_failed, total_tests_run)
    }
    else
    {
        show_debug_message("ALL TESTS PASSED")
    }
    show_debug_message("TOTAL TESTS RUN: {0}", total_tests_run)
}

function test_projection(name, from, onto, expected, current_total_and_failed)
{
    current_total_and_failed[0] += 1
    var result = project_vector(from[0], from[1], onto[0], onto[1])
    if result[0] != expected[0] or result[1] != expected[1]
    {
        current_total_and_failed[1] += 1
        show_debug_message("TEST #{0} FAILED '{1}'; expected: {2}, actual: {3}", current_total_and_failed[0], name, expected, result)
    }
}