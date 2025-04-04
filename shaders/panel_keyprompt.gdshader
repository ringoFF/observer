shader_type canvas_item;

uniform sampler2D screen_texture_gray : hint_screen_texture, filter_nearest;

void fragment()
{
	vec4 screen_color = texture(screen_texture_gray, SCREEN_UV);
	
	float grayscale = screen_color.r * 0.299 + screen_color.g * 0.587 + screen_color.b * 0.114;
	
	screen_color.rgb = vec3(grayscale);
	
	COLOR = screen_color;
}


