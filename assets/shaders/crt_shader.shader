shader_type canvas_item;

uniform float boost : hint_range(1.0, 2.0, 0.01) = float(1.2);
uniform float grille_opacity : hint_range(0.0, 1.0, 0.01) = float(0.85);
uniform float scanlines_opacity : hint_range(0.0, 1.0, 0.01) = float(0.95);
uniform float vignette_opacity : hint_range(0.1, 0.5, 0.01) = float(0.2);
uniform float scanlines_speed : hint_range(0.0, 1.0, 0.01) = float(1.0);
uniform bool show_grille = false;
uniform bool show_scanlines = true;
uniform bool show_vignette = true;
uniform bool show_curvature = true; // Curvature works best on stretch mode 2d.
uniform vec2 curvature_amount = vec2(7.0, 4.0);
uniform vec2 screen_size = vec2(320.0, 180.0);
uniform float aberration_amount : hint_range(0.0, 10.0, 1.0) = float(0.0);
uniform bool move_aberration = false;
uniform float aberration_speed : hint_range(0.01, 10.0, 0.01) = float(1.0);
uniform bool pause = false;
uniform float pause_alpha : hint_range(0.01, 3.0, 0.01) = float(1.0);
uniform bool lines = false;
uniform float lines_strength : hint_range(0.5, 3.0, 0.1) = float(1.0);
uniform float lower_bound : hint_range(0.01, 0.9, 0.01) = float(0.7);
uniform float upper_bound : hint_range(0.1, 1.0, 0.01) = float(0.95);
uniform int num_lines : hint_range(1, 10, 1) = int(4);
uniform float angle : hint_range(-10.0, 10.0, 0.1) = float(2.0);

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 CRTCurveUV(vec2 uv) {
	if(show_curvature) {
		uv = uv * 2.0 - 1.0;
		vec2 offset = abs(uv.yx) / curvature_amount;
		uv = uv + uv * offset * offset;
		uv = uv * 0.5 + 0.5;
	}
	return uv;
}

void DrawPause(inout vec4 color, sampler2D tex, in float time, vec2 uv) {
	float iGlobalTime = time;
	vec2 fragCoord = uv;
	vec4 texColor = vec4(0);

	vec2 samplePosition = uv;
	float whiteNoise = 9999.0;

	samplePosition.x = samplePosition.x+(rand(vec2(iGlobalTime,fragCoord.y))-0.5)/64.0;
	samplePosition.y = samplePosition.y+(rand(vec2(iGlobalTime))-0.5)/64.0;
	//texColor = texColor + (vec4(-0.5)+vec4(rand(vec2(fragCoord.y,iGlobalTime)),rand(vec2(fragCoord.y,iGlobalTime+1.0)),rand(vec2(fragCoord.y,iGlobalTime)),0))*0.1;

	whiteNoise = rand(vec2(floor(samplePosition.y*80.0),floor(samplePosition.x*50.0))+vec2(iGlobalTime,0));
	if (whiteNoise > 11.5-30.0*samplePosition.y || whiteNoise < 1.5-5.0*samplePosition.y) {
		texColor = texColor + texture(tex,(samplePosition));
	}
	else {
		texColor = texColor + texture(tex,(samplePosition));
		texColor *= 1.0 + pause_alpha;
	}
	color.r = texColor.r;
	color.g = texColor.g;
	color.b = texColor.b;
	color.a = texColor.a;
}

float noise(vec2 p, sampler2D tex, float iTime) {
	float s = texture(tex,vec2(1.0,2.0*cos(iTime))*iTime*8.0 + p*1.0).x;
	s *= s;
	return s;
}

float ramp(float y, float start, float end) {
	float inside = step(start,y) - step(end,y);
	float fact = (y-start)/(end-start)*inside;
	return (1.0-fact) * inside;
	
}

float DrawStripes(sampler2D tex, in float time, vec2 uv) {
	float noi = noise(uv*vec2(0.5, 1.0) + vec2(1.0, 3.0), tex, time);
	return ramp(mod(uv.x*angle - uv.y*float(num_lines) + time/2.+sin(time + sin(time*0.63)),1.0),lower_bound,upper_bound)*noi;
}

void DrawVignette(inout vec3 color, vec2 uv) {
	if(show_vignette) {
		float vignette = uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
		vignette = clamp(pow((screen_size.x / 4.0) * vignette, vignette_opacity), 0.0, 1.0);
		color *= vignette;
	} else {
		return;
	}
}

void DrawScanline(inout vec3 color, vec2 uv, float time) {
	float scanline = clamp((scanlines_opacity - 0.05) + 0.05 * sin(3.1415926535 * (uv.y + 0.008 * time) * screen_size.y), 0.0, 1.0);
	float grille = (grille_opacity - 0.15) + 0.15 * clamp(1.5 * sin(3.1415926535 * uv.x * screen_size.x), 0.0, 1.0);

	if (show_scanlines) {
		color *= scanline;
	}

	if (show_grille) {
		color *= grille;
	}

	color *= boost;
}

void fragment() {
	vec2 screen_crtUV = CRTCurveUV(SCREEN_UV);
	vec3 color = texture(SCREEN_TEXTURE, screen_crtUV).rgb;
	
	if (aberration_amount > 0.0) {
		float adjusted_amount = aberration_amount / screen_size.y;
		
		if (move_aberration == true) {
			adjusted_amount = (aberration_amount / screen_size.y) * cos((2.0 * 3.14159265359) * (TIME / aberration_speed));
		} 
		
		color.r = texture(SCREEN_TEXTURE, vec2(screen_crtUV.x, screen_crtUV.y + adjusted_amount)).r;
		color.g = texture(SCREEN_TEXTURE, screen_crtUV).g;
		color.b = texture(SCREEN_TEXTURE, vec2(screen_crtUV.x, screen_crtUV.y - adjusted_amount)).b;
	}
	
	vec4 col = vec4(color, pause_alpha);
	if (pause) {
		DrawPause(col, SCREEN_TEXTURE, TIME, SCREEN_UV);
	}
	color.r = col.r;
	color.g = col.g;
	color.b = col.b;
		
	vec2 crtUV = CRTCurveUV(UV);
	if (crtUV.x < 0.0 || crtUV.x > 1.0 || crtUV.y < 0.0 || crtUV.y > 1.0) {
		color = vec3(0.0, 0.0, 0.0);
	}
	
	DrawVignette(color, crtUV);
	DrawScanline(color, crtUV, TIME * scanlines_speed);
	if (lines) {
		color += lines_strength*DrawStripes(SCREEN_TEXTURE, TIME, SCREEN_UV);
	}
	
	COLOR = vec4(color, 1);
}