shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform sampler2D noise_tex1 : repeat_enable;
uniform sampler2D noise_tex2 : repeat_enable;
uniform float distortion_strength : hint_range(-1.0, 1.0) = 0.1;
uniform vec2 offset1 = vec2(0.1);
uniform vec2 offset2 = vec2(0.2);

uniform bool isgray = true;

void fragment() {
	if (!isgray)
	{
		vec4 noise_color1 = texture(noise_tex1, UV + offset1 * TIME);
		vec4 noise_color2 = texture(noise_tex2, UV + offset2 * TIME);
		
		float final_noise = noise_color1.r * noise_color2.r;
		
		vec4 final_color = texture(screen_texture, SCREEN_UV + final_noise * distortion_strength);
		
		COLOR = final_color;
	}
	else
	{
		vec4 screen_color = texture(screen_texture, SCREEN_UV);
		
		float grayscale = screen_color.r * 0.299 + screen_color.g * 0.587 + screen_color.b * 0.114;
		
		screen_color.rgb = vec3(grayscale);
		
		COLOR = screen_color;
	}
}