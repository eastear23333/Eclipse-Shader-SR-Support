#include "/lib/settings.glsl"

#include "/lib/SSBOs.glsl"

out DATA {
	flat vec2 TAA_Offset;

	#ifdef OVERWORLD_SHADER
		flat vec3 WsunVec;
	#endif
};

uniform sampler2D colortex4;

uniform int frameCounter;

uniform float sunElevation;
uniform vec3 sunPosition;
uniform mat4 gbufferModelViewInverse;


uniform float far;
uniform float near;

#include "/lib/util.glsl"
#include "/lib/res_params.glsl"

uniform int framemod8;

#if defined SR_INSTALLED && SR_SHOULD_APPLY_JITTER && SR_ALGO_SUPPORTS_JITTER
	uniform vec2 SRJitterOffset;
#endif

#include "/lib/TAA_jitter.glsl"

void main() {
	gl_Position = ftransform();

	#ifdef OVERWORLD_SHADER
		#ifdef CUSTOM_MOON_ROTATION
			vec3 moonVec = customMoonVecSSBO;
			#ifdef SMOOTH_SUN_ROTATION
				WsunVec = WsunVecSmooth;
			#else
				WsunVec = normalize(mat3(gbufferModelViewInverse) * sunPosition);
			#endif
			WsunVec = mix(moonVec, WsunVec, float(sunElevation > 1e-5));
			// WsunVec = moonVec;
		#else
			WsunVec = (float(sunElevation > 1e-5)*2-1.)*normalize(mat3(gbufferModelViewInverse) * sunPosition);
		#endif
	#endif

#if defined SR_INSTALLED && SR_SHOULD_APPLY_JITTER && SR_ALGO_SUPPORTS_JITTER
	TAA_Offset = SRJitterOffset;
#elif defined TAA
	TAA_Offset = offsets[framemod8];
#else
	TAA_Offset = vec2(0.0);
#endif

#if defined SR_INSTALLED && SR_SHOULD_APPLY_SCALE || defined TAA_UPSCALING
	gl_Position.xy = (gl_Position.xy*0.5+0.5)*RENDER_SCALE*2.0-1.0;
#endif
}
