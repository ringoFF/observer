shader_type canvas_item;

uniform sampler2D noise_tex1 : repeat_enable;
uniform sampler2D noise_tex2 : repeat_enable;
uniform float distortion_strength : hint_range(-1.0, 1.0) = 0.1;
uniform vec2 offset1 = vec2(0.1);
uniform vec2 offset2 = vec2(0.2);

void fragment()
{
	vec4 noise_color1 = texture(noise_tex1, UV + offset1 * TIME);
	vec4 noise_color2 = texture(noise_tex2, UV + offset2 * TIME);
	
	float final_noise = noise_color1.r * noise_color2.r;
	
	vec4 final_color = texture(TEXTURE, UV + final_noise * distortion_strength);

	final_color.rgb = vec3(0.0, 0.0, 0.0);

	final_color.a *= 0.9;
	
	COLOR = final_color;
}

