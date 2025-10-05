view_enabled = false//true
view_camera[0] = camera_create_view(0,0,480,270)
view_set_visible(0,true)
view_set_camera(0,view_camera[0])
cam_width = camera_get_view_width(view_camera[0])
cam_height = camera_get_view_height(view_camera[0])
