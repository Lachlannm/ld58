image_alpha -= 0.02
image_xscale += 0.05
image_yscale += 0.05
image_angle += rotate
if image_alpha <= 0
{
	instance_destroy()	
}