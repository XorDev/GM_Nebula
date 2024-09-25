///@desc Update

//Animate vars
time += delta_time/1000000;
shock += delta_time/1000000;

//Follow mouse smoothly
hspeed = lerp(hspeed, (mouse_x-x)/100, 0.5);
vspeed = lerp(vspeed, (mouse_y-y)/100, 0.5);

//Randomize params
if mouse_check_button_pressed(mb_left) 
{
	shock = 0;
	time = random(1000);
	depth_amount = exp(random(.3));
}
//Shock
if mouse_check_button_pressed(mb_right) shock = 0;

//Shockwave darkness
darkness = lerp(darkness, 1/(1+shock), 0.1);

//Update depth factor with mouse wheel
depth_amount *= exp((mouse_wheel_up()-mouse_wheel_down())/100);
depth_amount = min(depth_amount,1.4);
depth_smooth = lerp(depth_smooth, depth_amount, 0.2);