#include "/lib/res_params.glsl"

void main() {
	gl_Position = ftransform();

#if defined SR_INSTALLED && SR_SHOULD_APPLY_SCALE || defined TAA_UPSCALING
	gl_Position.xy = (gl_Position.xy*0.5+0.5)*RENDER_SCALE*2.0-1.0;
#endif
}
