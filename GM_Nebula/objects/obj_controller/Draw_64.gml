///@desc Draw nebula

gpu_set_texrepeat(true);
shader_set(shd_nebula);
shader_set_uniform_f(u_pos,-x/1000,-y/1000);
shader_set_uniform_f(u_time,time);
shader_set_uniform_f(u_shock,shock,darkness);
shader_set_uniform_f(u_depth,depth_smooth);
draw_sprite_stretched(spr_nebula,0,0,0,w,h);
shader_reset();