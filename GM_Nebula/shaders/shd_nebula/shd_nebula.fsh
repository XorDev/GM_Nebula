varying vec2 v_coord;
varying vec4 v_color;

//Camera position (use small values)
uniform vec2 u_pos;
//Shockwave animation time and luminance intensity
uniform vec2 u_shock;
//Nebula depth factor (keep around 1 to 1.4)
uniform float u_depth;
//Time for animations (in seconds)
uniform float u_time;

//Correcting texture coordinates (could be replaced with a uniform)
#define SCREEN_RATIO vec2(16.0/9.0, 1.0)
//Correction for nebula texture aspect ratio
#define TEX_RATIO vec2(4.0/3.0, 1.0)

//Nebula base scale
#define NEB_SCALE 0.3
//Nebula velocity (texture units per second)
#define NEB_VELOCITY vec2(0.003,0.003)
//Nebula distortion intensity (0 = no distortion)
#define NEB_DISTORTION 0.1
//Nebula color tint amplitude
#define NEB_COLOR_AMP 0.2
//Nebula color animation rate
#define NEB_COLOR_RATE 0.1
//Nebula color wave frequency (higher = more waves)
#define NEB_COLOR_FREQ 3.0

//Shockwave speed (texture units per second)
#define SHOCK_SPEED 0.4
//Shockwave wave frequency (higher = more ripples)
#define SHOCK_FREQ 50.0
//Shockwave wave amplitude
#define SHOCK_AMP 0.04

// Narkowicz 2015, "ACES Filmic Tone Mapping Curve"
// https://www.shadertoy.com/view/llXyWr
vec3 Tonemap_ACES(vec3 x)
{
    const float a = 2.51;
    const float b = 0.03;
    const float c = 2.43;
    const float d = 0.59;
    const float e = 0.14;
    return (x * (a * x + b)) / (x * (c * x + d) + e);
}
void main()
{
	//Scaled and ratio-corrected coordinates
	vec2 coord = (v_coord-0.5) * SCREEN_RATIO * NEB_SCALE;
	
	//SHOCKWAVES
	//Shockwave distance
	float wave = (length(coord) - u_shock.x*SHOCK_SPEED)*SHOCK_FREQ;
	//Amplitude with falloff
	float amp = max(min(-wave, 1.0/(1.0+0.1*wave*wave)), 0.0);
	//Cosine shock ripples
	float ripple = cos(wave) * amp;
	//Add shockwave to coordinates
	coord += coord * ripple * SHOCK_AMP;
	
	//NEBULA
	//Output color
	vec4 col = vec4(0);
	//Rotation matrix for octaves
	mat2 rot = mat2(0.8,-0.6,0.6,0.8);
	//Octave scale
	float scale = 1.0;
	//Iterate through 10 texture layers
	for(float i = 0.0; i<10.0; i++)
	{
		//Compute octave uvs
		vec2 uv = u_time*NEB_VELOCITY + rot*coord*scale - rot*u_pos.xy + col.gb*(1.-col.rg)*NEB_DISTORTION + i/7.3;
		//Sample octave texture
		vec4 tex = texture2D(gm_BaseTexture, uv / TEX_RATIO);
		//Add to color total with brighter whites
		col += 0.15*tex / dot(1.0-tex, 1.0-tex);
		
		//Rotate and scale next octave
		rot *= mat2(0.6, -0.8, 0.8, 0.6);
		scale *= u_depth;
	}
	//Square for gamma 2.0
	col.rgb *= col.rgb;
	//Apply color tinting
	col.rgb *= mix(vec3(1), sin(v_coord.xyx*NEB_COLOR_FREQ+vec3(0,2,3)+NEB_COLOR_RATE*u_time), NEB_COLOR_AMP);
	//Apply shockwave coloring
	col.rgb *= 1.0-clamp(1.0-amp,0.0,1.0)*(1.0+vec3(-40,0,40)*dFdx(ripple)) * u_shock.y;
	//Tonemap back to sRGB
	col.rgb = Tonemap_ACES(col.rgb);
	//Grayscale test:
	//col.rgb = col.rgb*.1+.3*(col.r+col.g+col.b);
	
	//Apply chromatic aberration
	col.rgb -= dFdx(col.rgb)*vec3(2,0,-2);
	//Make sure it's opaque
	col.a = 1.0;
    gl_FragColor = col;
}