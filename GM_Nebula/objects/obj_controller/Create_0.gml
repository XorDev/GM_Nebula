///@desc Init

//Screen res
w = window_get_width();
h = window_get_height();

//Enable mipmapping
gpu_set_tex_filter(true);
gpu_set_tex_mip_enable(true);

//Shader variables
time = 0;
depth_amount = 1.3;
depth_smooth = 1.2;
shock = 9;
darkness = 0;


//Shader uniforms
u_pos = shader_get_uniform(shd_nebula,"u_pos");
u_shock = shader_get_uniform(shd_nebula,"u_shock");
u_time = shader_get_uniform(shd_nebula,"u_time");
u_depth = shader_get_uniform(shd_nebula,"u_depth");