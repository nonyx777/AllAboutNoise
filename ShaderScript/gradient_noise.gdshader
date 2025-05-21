shader_type spatial;
//render_mode unshaded;

vec3 hash(vec3 p) {
    p = vec3(dot(p, vec3(127.1, 311.7, 74.7)),
             dot(p, vec3(269.5, 183.3, 246.1)),
             dot(p, vec3(113.5, 271.9, 124.6)));

    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec3 p) {
  vec3 i = floor(p);
  vec3 f = fract(p);
  vec3 u = f * f * (3.0 - 2.0 * f);

  return mix(mix(mix(dot(hash(i + vec3(0.0, 0.0, 0.0)), f - vec3(0.0, 0.0, 0.0)),
                     dot(hash(i + vec3(1.0, 0.0, 0.0)), f - vec3(1.0, 0.0, 0.0)), u.x),
                 mix(dot(hash(i + vec3(0.0, 1.0, 0.0)), f - vec3(0.0, 1.0, 0.0)),
                     dot(hash(i + vec3(1.0, 1.0, 0.0)), f - vec3(1.0, 1.0, 0.0)), u.x), u.y),
             mix(mix(dot(hash(i + vec3(0.0, 0.0, 1.0)), f - vec3(0.0, 0.0, 1.0)),
                     dot(hash(i + vec3(1.0, 0.0, 1.0)), f - vec3(1.0, 0.0, 1.0)), u.x),
                 mix(dot(hash(i + vec3(0.0, 1.0, 1.0)), f - vec3(0.0, 1.0, 1.0)),
                     dot(hash(i + vec3(1.0, 1.0, 1.0)), f - vec3(1.0, 1.0, 1.0)), u.x), u.y), u.z );
}

float perlin(vec3 pos, float pers, int n){
	float total = 0.0;
	float frequency = 0.0;
	float amplitude = 0.0;
	for(int i = 0; i < n; i++){
		frequency = pow(2.0, float(i));
		amplitude = pow(pers, float(i));
		total += noise(pos * frequency) * amplitude;
	}
	return total;
}

void fragment() {
        float theta = UV.y * PI;
        float phi = UV.x * PI * 2.0;
        vec3 unit = vec3(0.0, 0.0, 0.0);

        unit.x = sin(phi) * sin(theta);
        unit.y = cos(theta) * -1.0;
        unit.z = cos(phi) * sin(theta);
        unit = normalize(unit);
        float n = perlin(unit, 0.8, 8);
        ALBEDO = mix(vec3(0.0, 0.0, 1.0), vec3(1.0, 0.0, 0.0), smoothstep(-0.1, 0.0, n));
        //COLOR.a = 0.3 + 0.7 * smoothstep(-0.1, 0.0, n);
		ROUGHNESS = mix(0.0, 1.0, n * 0.5 + 0.5);
}