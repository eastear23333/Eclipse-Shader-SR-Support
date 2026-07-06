#include "/lib/settings.glsl"

#if RESOURCEPACK_SKY == 1 || RESOURCEPACK_SKY == 2
	#include "/lib/res_params.glsl"
	/*
	!! DO NOT REMOVE !!
	This code is from Chocapic13' shaders
	Read the terms of modification and sharing before changing something below please !
	!! DO NOT REMOVE !!
	*/
	out vec4 color;
	out vec2 texcoord;
uniform vec2 texelSize;
uniform int framemod8;

#if defined SR_INSTALLED && SR_SHOULD_APPLY_JITTER && SR_ALGO_SUPPORTS_JITTER
	uniform vec2 SRJitterOffset;
#endif

const vec2[8] offsets = vec2[8](vec2(1./8.,-3./8.),
								vec2(-1.,3.)/8.,
								vec2(5.0,1.)/8.,
								vec2(-3,-5.)/8.,
								vec2(-5.,5.)/8.,
								vec2(-7.,-1.)/8.,
								vec2(3,7.)/8.,
								vec2(7.,-7.)/8.);

#endif

void main() {
	gl_Position = ftransform();
	
	#if RESOURCEPACK_SKY == 1 || RESOURCEPACK_SKY == 2

		color = gl_Color;

		#if defined SR_INSTALLED && SR_SHOULD_APPLY_SCALE
			gl_Position.xy = gl_Position.xy * SR_RENDER_SCALE_FACTOR + (SR_RENDER_SCALE_FACTOR - 1.0) * gl_Position.w;
		#elif defined TAA_UPSCALING
			gl_Position.xy = gl_Position.xy * RENDER_SCALE + RENDER_SCALE * gl_Position.w - gl_Position.w;
		#endif
		#if defined SR_INSTALLED && SR_SHOULD_APPLY_JITTER && SR_ALGO_SUPPORTS_JITTER
			gl_Position.xy += SRJitterOffset * gl_Position.w*texelSize;
		#elif defined TAA
			gl_Position.xy += offsets[framemod8] * gl_Position.w*texelSize;
		#endif
		
	#endif
}