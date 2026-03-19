shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

// overall image
uniform float pixel_size : hint_range(1.0, 4.0) = 2.0;
uniform float lod_blur : hint_range(0.0, 2.0) = 0.7;
uniform float chroma_offset_px : hint_range(0.0, 3.0) = 0.8;
uniform float saturation : hint_range(0.0, 2.0) = 0.78;
uniform float contrast : hint_range(0.5, 1.5) = 0.90;
uniform float shadow_lift : hint_range(0.0, 0.25) = 0.06;
uniform float scanline_strength : hint_range(0.0, 0.20) = 0.04;
uniform float vignette_strength : hint_range(0.0, 0.5) = 0.10;

// animated noise
uniform float noise_strength : hint_range(0.0, 0.12) = 0.025;
uniform float noise_speed : hint_range(0.0, 60.0) = 18.0;

// subtle always-on line wobble (in PIXELS, not UV)
uniform float base_jitter_px : hint_range(0.0, 0.50) = 0.08;
uniform float base_jitter_speed : hint_range(0.0, 40.0) = 12.0;

// glitch bursts
uniform float glitchiness : hint_range(0.0, 1.0) = 0.18;
uniform float glitch_rate : hint_range(0.0, 20.0) = 6.0;
uniform float glitch_shift_px : hint_range(0.0, 8.0) = 1.8;
uniform float glitch_window_min : hint_range(0.0, 0.20) = 0.03;
uniform float glitch_window_max : hint_range(0.0, 0.35) = 0.10;

// moving blue tracking band
uniform float blue_band_start_y : hint_range(0.0, 1.0) = 0.45;
uniform float blue_band_speed : hint_range(-1.5, 1.5) = 0.06;
uniform float blue_band_width : hint_range(0.002, 0.20) = 0.035;
uniform float blue_band_strength : hint_range(0.0, 0.30) = 0.10;
uniform float blue_band_glitch : hint_range(0.0, 1.0) = 0.25;
uniform float blue_band_distort_px : hint_range(0.0, 6.0) = 1.2;

float hash11(float p) {
	return fract(sin(p * 127.1) * 43758.5453123);
}

float hash21(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

vec3 sat_adjust(vec3 c, float s) {
	float l = dot(c, vec3(0.299, 0.587, 0.114));
	return mix(vec3(l), c, s);
}

vec3 sample_screen(vec2 uv, float lod) {
	return textureLod(screen_texture, clamp(uv, vec2(0.0), vec2(1.0)), lod).rgb;
}

void fragment() {
	vec2 px = SCREEN_PIXEL_SIZE;
	vec2 uv = SCREEN_UV;
	float t = TIME;
	float line_id = floor(FRAGCOORD.y);

	// mild blocky grouping to kill digital sharpness
	vec2 block = px * pixel_size;
	uv = floor(uv / block) * block;

	// subtle per-line wobble that updates over time
	float line_wobble = hash21(vec2(line_id, floor(t * base_jitter_speed)));
	uv.x += (line_wobble - 0.5) * base_jitter_px * px.x;

	// occasional glitch burst window
	float burst_id = floor(t * glitch_rate);
	float burst_rand = hash11(burst_id + 3.17);
	float burst_on = step(1.0 - glitchiness, burst_rand);

	float glitch_center = hash11(burst_id + 8.41);
	float glitch_half_height = mix(glitch_window_min, glitch_window_max, hash11(burst_id + 11.72));
	float glitch_mask = burst_on * (1.0 - smoothstep(0.0, glitch_half_height, abs(SCREEN_UV.y - glitch_center)));

	float glitch_line = hash21(vec2(line_id, burst_id + 31.3));
	uv.x += (glitch_line - 0.5) * glitch_shift_px * px.x * glitch_mask;

	// moving blue band with occasional jumpiness
	float band_tick = floor(t * 10.0);
	float band_jump = (hash11(band_tick + 55.2) - 0.5) * blue_band_glitch * 0.25;
	float band_center = fract(blue_band_start_y + t * blue_band_speed + band_jump);

	float band_dist = abs(SCREEN_UV.y - band_center);
	band_dist = min(band_dist, 1.0 - band_dist); // wrap nicely at top/bottom

	float band_mask = exp(
		-(band_dist * band_dist) /
		max(blue_band_width * blue_band_width, 0.000001)
	);

	float band_line = hash21(vec2(line_id, floor(t * 22.0) + 77.0));
	uv.x += (band_line - 0.5) * blue_band_distort_px * px.x * band_mask;

	// chroma split
	vec2 chroma_off = vec2(chroma_offset_px * px.x, 0.0);
	float r = sample_screen(uv + chroma_off, lod_blur).r;
	float g = sample_screen(uv, lod_blur).g;
	float b = sample_screen(uv - chroma_off, lod_blur).b;

	vec3 col = vec3(r, g, b);

	// overall VHS grade
	col = sat_adjust(col, saturation);
	col = (col - vec3(0.5)) * contrast + vec3(0.5);
	col += shadow_lift;

	// blue tracking tint
	col += vec3(0.02, 0.07, 0.18) * band_mask * blue_band_strength;

	// animated grain + line snow
	float grain = hash21(
		floor(FRAGCOORD.xy * 0.75) +
		vec2(floor(t * noise_speed), floor(t * noise_speed * 0.73))
	);

	float line_snow = hash21(vec2(line_id, floor(t * noise_speed * 0.5) + 100.0));

	col += ((grain - 0.5) * 0.7 + (line_snow - 0.5) * 0.3) * noise_strength;

	// scanlines
	float scan = sin((FRAGCOORD.y + t * 8.0) * 1.1) * 0.5 + 0.5;
	col *= 1.0 - scan * scanline_strength;

	// vignette
	vec2 centered = SCREEN_UV * 2.0 - 1.0;
	float vig = dot(centered, centered);
	col *= 1.0 - vig * vignette_strength;

	COLOR = vec4(clamp(col, vec3(0.0), vec3(1.0)), 1.0);
}