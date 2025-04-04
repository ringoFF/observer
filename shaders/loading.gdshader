shader_type canvas_item;

// 圆心坐标（基于 Sprite2D 的 UV 坐标系）
uniform vec2 center = vec2(0.5, 0.5); 
// 动态半径参数（通过脚本或动画控制）
uniform float radius : hint_range(0.0, 1.0) = 0.5;
// 边缘柔化参数（设为 0 时为硬切边）
uniform float edge_smooth : hint_range(0.0, 0.2) = 0.02;

void fragment() {
    // 计算当前像素到圆心的距离
    float dist = distance(UV, center);
    
    // 使用 smoothstep 控制透明度渐变
    float alpha = smoothstep(radius - edge_smooth, radius + edge_smooth, dist);
    
    // 输出颜色（保留原纹理颜色，仅控制透明度）
    // COLOR = texture(TEXTURE, UV);
	COLOR.rgb = vec3(0, 0, 0);
    COLOR.a = alpha;
}