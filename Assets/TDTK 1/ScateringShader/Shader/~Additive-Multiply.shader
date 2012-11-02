Shader "Particles/~Additive-Multiply" {
Properties {
	_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	_MainTex ("Particle Texture", 2D) = "white" {}
	_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend One OneMinusSrcAlpha
	ColorMask RGB
	Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,1) }
	BindChannels {
		Bind "Color", color
		Bind "Vertex", vertex
		Bind "TexCoord", texcoord
	}
	
	// ---- Fragment program cards
	SubShader {
		Pass {
		
			Program "vp" {
// Vertex combos: 2
//   opengl - ALU: 6 to 14
//   d3d9 - ALU: 6 to 14
SubProgram "opengl " {
Keywords { "SOFTPARTICLES_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Vector 5 [_MainTex_ST]
"!!ARBvp1.0
# 6 ALU
PARAM c[6] = { program.local[0],
		state.matrix.mvp,
		program.local[5] };
MOV result.color, vertex.color;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[5], c[5].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 6 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SOFTPARTICLES_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_ST]
"vs_2_0
; 6 ALU
dcl_position0 v0
dcl_color0 v1
dcl_texcoord0 v2
mov oD0, v1
mad oT0.xy, v2, c4, c4.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "xbox360 " {
Keywords { "SOFTPARTICLES_OFF" }
Bind "vertex" Vertex
Bind "color" COLOR
Bind "texcoord" TexCoord0
Vector 4 [_MainTex_ST]
Matrix 0 [glstate_matrix_mvp] 4
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 8.00 (6 instructions), vertex: 32, texture: 0,
//   sequencer: 10,  4 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabaeaaaaaajmaaaaaaaaaaaaaaceaaaaaaaaaaaaaamaaaaaaaaa
aaaaaaaaaaaaaajiaaaaaabmaaaaaailpppoadaaaaaaaaacaaaaaabmaaaaaaaa
aaaaaaieaaaaaaeeaaacaaaeaaabaaaaaaaaaafaaaaaaaaaaaaaaagaaaacaaaa
aaaeaaaaaaaaaaheaaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaae
aaabaaaaaaaaaaaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaaklaaadaaad
aaaeaaaeaaabaaaaaaaaaaaahghdfpddfpdaaadccodacodcdadddfddcodaaakl
aaaaaaaaaaaaaajmaabbaaadaaaaaaaaaaaaaaaaaaaabiecaaaaaaabaaaaaaad
aaaaaaacaaaaacjaaabaaaadaaaakaaeaadafaafaaaadafaaaabpbkaaaaabaal
aaaabaakhabfdaadaaaabcaamcaaaaaaaaaaeaagaaaabcaameaaaaaaaaaacaak
aaaaccaaaaaaaaaaafpidaaaaaaaagiiaaaaaaaaafpibaaaaaaaagiiaaaaaaaa
afpiaaaaaaaaapmiaaaaaaaamiapaaacaabliiaakbadadaamiapaaacaamgiiaa
kladacacmiapaaacaalbdejekladabacmiapiadoaagmaadekladaaacmiapiaab
aaaaaaaaocababaamiadiaaaaalalabkilaaaeaeaaaaaaaaaaaaaaaaaaaaaaaa
"
}

SubProgram "ps3 " {
Keywords { "SOFTPARTICLES_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Vector 467 [_MainTex_ST]
"sce_vp_rsx // 6 instructions using 1 registers
[Configuration]
8
0000000601090100
[Microcode]
96
401f9c6c0040030d8106c0836041ff84401f9c6c011d3808010400d740619f9c
401f9c6c01d0300d8106c0c360403f80401f9c6c01d0200d8106c0c360405f80
401f9c6c01d0100d8106c0c360409f80401f9c6c01d0000d8106c0c360411f81
"
}

SubProgram "gles " {
Keywords { "SOFTPARTICLES_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
uniform lowp vec4 _TintColor;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 col;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0);
  col.xyz = (((_TintColor.xyz * tmpvar_1.xyz) * xlv_COLOR.xyz) * 2.0);
  col.w = ((1.0 - tmpvar_1.w) * ((_TintColor.w * xlv_COLOR.w) * 2.0));
  gl_FragData[0] = col;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SOFTPARTICLES_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
uniform lowp vec4 _TintColor;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 col;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0);
  col.xyz = (((_TintColor.xyz * tmpvar_1.xyz) * xlv_COLOR.xyz) * 2.0);
  col.w = ((1.0 - tmpvar_1.w) * ((_TintColor.w * xlv_COLOR.w) * 2.0));
  gl_FragData[0] = col;
}



#endif"
}

SubProgram "flash " {
Keywords { "SOFTPARTICLES_OFF" }
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_MainTex_ST]
"agal_vs
[bc]
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
adaaaaaaaaaaadacadaaaaoeaaaaaaaaaeaaaaoeabaaaaaa mul r0.xy, a3, c4
abaaaaaaaaaaadaeaaaaaafeacaaaaaaaeaaaaooabaaaaaa add v0.xy, r0.xyyy, c4.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
"
}

SubProgram "opengl " {
Keywords { "SOFTPARTICLES_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [_MainTex_ST]
"!!ARBvp1.0
# 14 ALU
PARAM c[11] = { { 0.5 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..10] };
TEMP R0;
TEMP R1;
DP4 R1.w, vertex.position, c[8];
DP4 R0.x, vertex.position, c[5];
MOV R0.w, R1;
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
DP4 R0.z, vertex.position, c[7];
MOV result.position, R0;
DP4 R0.x, vertex.position, c[3];
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.color, vertex.color;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MOV result.texcoord[1].z, -R0.x;
MOV result.texcoord[1].w, R1;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SOFTPARTICLES_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [_MainTex_ST]
"vs_2_0
; 14 ALU
def c11, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_color0 v1
dcl_texcoord0 v2
dp4 r1.w, v0, c7
dp4 r0.x, v0, c4
mov r0.w, r1
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c11.x
mul r1.y, r1, c8.x
dp4 r0.z, v0, c6
mov oPos, r0
dp4 r0.x, v0, c2
mad oT1.xy, r1.z, c9.zwzw, r1
mov oD0, v1
mad oT0.xy, v2, c10, c10.zwzw
mov oT1.z, -r0.x
mov oT1.w, r1
"
}

SubProgram "xbox360 " {
Keywords { "SOFTPARTICLES_ON" }
Bind "vertex" Vertex
Bind "color" COLOR
Bind "texcoord" TexCoord0
Vector 10 [_MainTex_ST]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Matrix 4 [glstate_matrix_modelview0] 4
Matrix 0 [glstate_matrix_mvp] 4
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 20.00 (15 instructions), vertex: 32, texture: 0,
//   sequencer: 12,  5 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaableaaaaabeiaaaaaaaaaaaaaaceaaaaabdiaaaaabgaaaaaaaaa
aaaaaaaaaaaaabbaaaaaaabmaaaaabacpppoadaaaaaaaaafaaaaaabmaaaaaaaa
aaaaaaplaaaaaaiaaaacaaakaaabaaaaaaaaaaimaaaaaaaaaaaaaajmaaacaaai
aaabaaaaaaaaaaimaaaaaaaaaaaaaakoaaacaaajaaabaaaaaaaaaaimaaaaaaaa
aaaaaalmaaacaaaeaaaeaaaaaaaaaaniaaaaaaaaaaaaaaoiaaacaaaaaaaeaaaa
aaaaaaniaaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhc
gbgnhdaaghgmhdhegbhegffpgngbhehcgjhifpgngpgegfgmhggjgfhhdaaaklkl
aaadaaadaaaeaaaeaaabaaaaaaaaaaaaghgmhdhegbhegffpgngbhehcgjhifpgn
hghaaahghdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaaaaaaaaab
aaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaeaaaaaabaiaacbaaaeaaaaaaaaaaaaaaaaaaaacigdaaaaaaabaaaaaaad
aaaaaaafaaaaacjaaabaaaadaaaakaaeaacafaafaaaadafaaaabpbfbaaaepcka
aaaababcaaaaaaapaaaaaabaaaaababeaaaababbaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahabfdaadaaaabcaamcaaaaaa
aaaafaagaaaabcaameaaaaaaaaaagaaleabbbcaaccaaaaaaafpidaaaaaaaagii
aaaaaaaaafpicaaaaaaaagiiaaaaaaaaafpibaaaaaaaapmiaaaaaaaamiapaaaa
aabliiaakbadadaamiapaaaaaamgaaiikladacaamiapaaaaaalbdedekladabaa
miapaaaeaagmnajekladaaaamiapiadoaananaaaocaeaeaamiabaaaaaamgmgaa
kbadagaamiabaaaaaalbmggmkladafaamiaiaaaaaagmmggmkladaeaamiahaaaa
aamagmaakbaeppaabeiaiaabaaaaaamgocaaaaaemiaeiaabafblmgblkladahaa
miapiaacaaaaaaaaocacacaamiadiaaaaalalabkilabakakkiiaaaaaaaaaaaeb
mcaaaaaimiadiaabaamgbkbiklaaajaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "SOFTPARTICLES_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Matrix 260 [glstate_matrix_modelview0]
Vector 467 [_ProjectionParams]
Vector 466 [_MainTex_ST]
"sce_vp_rsx // 13 instructions using 2 registers
[Configuration]
8
0000000d01090200
[Defaults]
1
465 1
3f000000
[Microcode]
208
401f9c6c0040030d8106c0836041ff84401f9c6c011d2808010400d740619f9c
00001c6c01d0200d8106c0c360405ffc00001c6c01d0100d8106c0c360409ffc
00001c6c01d0000d8106c0c360411ffc00001c6c01d0600d8106c0c360403ffc
00009c6c01d0300d8106c0c360411ffc401f9c6c004000ff8086c08360405fa0
40001c6c004000000286c08360403fa0401f9c6c0040000d8086c0836041ff80
00001c6c009d100e008000c36041dffc00001c6c009d302a808000c360409ffc
401f9c6c00c000080086c09540219fa1
"
}

SubProgram "gles " {
Keywords { "SOFTPARTICLES_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;


uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1 = o_i0;
  tmpvar_1.z = -((gl_ModelViewMatrix * _glesVertex).z);
  gl_Position = tmpvar_2;
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
uniform highp vec4 _ZBufferParams;
uniform lowp vec4 _TintColor;
uniform sampler2D _MainTex;
uniform highp float _InvFade;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  lowp vec4 col;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD1);
  highp float z;
  z = tmpvar_2.x;
  highp vec4 tmpvar_3;
  tmpvar_3 = (xlv_COLOR * clamp ((_InvFade * ((1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w))) - xlv_TEXCOORD1.z)), 0.0, 1.0));
  tmpvar_1 = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  col.xyz = (((_TintColor.xyz * tmpvar_4.xyz) * tmpvar_1.xyz) * 2.0);
  col.w = ((1.0 - tmpvar_4.w) * ((_TintColor.w * tmpvar_1.w) * 2.0));
  gl_FragData[0] = col;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SOFTPARTICLES_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;


uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1 = o_i0;
  tmpvar_1.z = -((gl_ModelViewMatrix * _glesVertex).z);
  gl_Position = tmpvar_2;
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
uniform highp vec4 _ZBufferParams;
uniform lowp vec4 _TintColor;
uniform sampler2D _MainTex;
uniform highp float _InvFade;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  lowp vec4 col;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2DProj (_CameraDepthTexture, xlv_TEXCOORD1);
  highp float z;
  z = tmpvar_2.x;
  highp vec4 tmpvar_3;
  tmpvar_3 = (xlv_COLOR * clamp ((_InvFade * ((1.0/(((_ZBufferParams.z * z) + _ZBufferParams.w))) - xlv_TEXCOORD1.z)), 0.0, 1.0));
  tmpvar_1 = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  col.xyz = (((_TintColor.xyz * tmpvar_4.xyz) * tmpvar_1.xyz) * 2.0);
  col.w = ((1.0 - tmpvar_4.w) * ((_TintColor.w * tmpvar_1.w) * 2.0));
  gl_FragData[0] = col;
}



#endif"
}

SubProgram "flash " {
Keywords { "SOFTPARTICLES_ON" }
Bind "vertex" Vertex
Bind "color" Color
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_NPOTScale]
Vector 10 [_MainTex_ST]
"agal_vs
c11 0.5 0.0 0.0 0.0
[bc]
bdaaaaaaabaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r1.w, a0, c7
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
adaaaaaaabaaahacaaaaaapeacaaaaaaalaaaaaaabaaaaaa mul r1.xyz, r0.xyww, c11.x
adaaaaaaabaaacacabaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r1.y, c8.x
abaaaaaaabaaadacabaaaafeacaaaaaaabaaaakkacaaaaaa add r1.xy, r1.xyyy, r1.z
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.x, a0, c2
adaaaaaaabaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v1.xy, r1.xyyy, c9
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
adaaaaaaacaaadacadaaaaoeaaaaaaaaakaaaaoeabaaaaaa mul r2.xy, a3, c10
abaaaaaaaaaaadaeacaaaafeacaaaaaaakaaaaooabaaaaaa add v0.xy, r2.xyyy, c10.zwzw
bfaaaaaaabaaaeaeaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg v1.z, r0.x
aaaaaaaaabaaaiaeabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.w, r1.w
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
"
}

}
Program "fp" {
// Fragment combos: 2
//   opengl - ALU: 8 to 14, TEX: 1 to 2
//   d3d9 - ALU: 8 to 13, TEX: 1 to 2
SubProgram "opengl " {
Keywords { "SOFTPARTICLES_OFF" }
Vector 0 [_TintColor]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 8 ALU, 1 TEX
PARAM c[2] = { program.local[0],
		{ 1, 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0.xyz, R0, c[0];
MUL R0.xyz, fragment.color.primary, R0;
ADD R0.w, -R0, c[1].x;
MUL R1.x, fragment.color.primary.w, c[0].w;
MUL R0.w, R1.x, R0;
MUL result.color.w, R0, c[1].y;
MUL result.color.xyz, R0, c[1].y;
END
# 8 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SOFTPARTICLES_OFF" }
Vector 0 [_TintColor]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 8 ALU, 1 TEX
dcl_2d s0
def c1, 1.00000000, 2.00000000, 0, 0
dcl v0
dcl t0.xy
texld r0, t0, s0
mul_pp r0.xyz, r0, c0
mul_pp r2.xyz, v0, r0
add_pp r1.x, -r0.w, c1
mul_pp r0.x, v0.w, c0.w
mul r0.x, r0, r1
mul r1.xyz, r2, c1.y
mul r1.w, r0.x, c1.y
mov_pp oC0, r1
"
}

SubProgram "xbox360 " {
Keywords { "SOFTPARTICLES_OFF" }
Vector 0 [_TintColor]
SetTexture 0 [_MainTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 6.67 (5 instructions), vertex: 0, texture: 4,
//   sequencer: 6, interpolator: 16;    3 GPRs, 63 threads,
// Performance (if enough threads): ~16 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabaiaaaaaakmaaaaaaaaaaaaaaceaaaaaaliaaaaaaoaaaaaaaaa
aaaaaaaaaaaaaajaaaaaaabmaaaaaaidppppadaaaaaaaaacaaaaaabmaaaaaaaa
aaaaaahmaaaaaaeeaaadaaaaaaabaaaaaaaaaafaaaaaaaaaaaaaaagaaaacaaaa
aaabaaaaaaaaaagmaaaaaaaafpengbgjgofegfhiaaklklklaaaeaaamaaabaaab
aaabaaaaaaaaaaaafpfegjgoheedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaa
aaaaaaaahahdfpddfpdaaadccodacodcdadddfddcodaaaklaaaaaaaaaaaaaaab
aaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaeaaaaaaagmbaaaacaaaaaaaaaiaaaaaaaaaaaabiecaaabaaadaaaaaaab
aaaadafaaaaapbkaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpiaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaabbaacaaaabcaameaaaaaaaaaafaadaaaaccaaaaaaaaaa
baaicaabbpbppgiiaaaaeaaaaabaaaabaaaaaablmcababaabeaoabaaaapmpmgm
kbabaaaaamibabaaaeblgmblkaacppabbeahababaamamabloaacacabamihiaaa
aabfmagmobaaabaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "SOFTPARTICLES_OFF" }
Vector 0 [_TintColor]
SetTexture 0 [_MainTex] 2D
"sce_fp_rsx // 10 instructions using 2 registers
[Configuration]
24
ffffffff000040250001ffff000000000000840002000000
[Offsets]
1
_TintColor 2 0
0000007000000030
[Microcode]
160
9e021700c8011c9dc8000001c8003fe13e800140c8011c9dc8000001c8003fe1
0e820240c8041c9dc8020001c800000100000000000000000000000000000000
10820340c8041c9fc8020001c800000100000000000000000000000000003f80
10800240c9001c9dc8020001c800000100000000000000000000000000000000
0e800240c9001c9dc9041001c800000110810200c9001c9dc9041001c8000001
"
}

SubProgram "gles " {
Keywords { "SOFTPARTICLES_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SOFTPARTICLES_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "SOFTPARTICLES_OFF" }
Vector 0 [_TintColor]
SetTexture 0 [_MainTex] 2D
"agal_ps
c1 1.0 2.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
adaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r0.xyz, r0.xyzz, c0
adaaaaaaacaaahacahaaaaoeaeaaaaaaaaaaaakeacaaaaaa mul r2.xyz, v7, r0.xyzz
bfaaaaaaabaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r0.w
abaaaaaaabaaabacabaaaappacaaaaaaabaaaaoeabaaaaaa add r1.x, r1.w, c1
adaaaaaaaaaaabacahaaaappaeaaaaaaaaaaaappabaaaaaa mul r0.x, v7.w, c0.w
adaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r0.x, r0.x, r1.x
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaaffabaaaaaa mul r1.xyz, r2.xyzz, c1.y
adaaaaaaabaaaiacaaaaaaaaacaaaaaaabaaaaffabaaaaaa mul r1.w, r0.x, c1.y
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "SOFTPARTICLES_ON" }
Vector 0 [_ZBufferParams]
Vector 1 [_TintColor]
Float 2 [_InvFade]
SetTexture 0 [_CameraDepthTexture] 2D
SetTexture 1 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 14 ALU, 2 TEX
PARAM c[4] = { program.local[0..2],
		{ 1, 2 } };
TEMP R0;
TEMP R1;
TEX R1, fragment.texcoord[0], texture[1], 2D;
TXP R0.x, fragment.texcoord[1], texture[0], 2D;
MAD R0.x, R0, c[0].z, c[0].w;
RCP R0.x, R0.x;
ADD R0.x, R0, -fragment.texcoord[1].z;
MUL_SAT R0.x, R0, c[2];
MUL R0, fragment.color.primary, R0.x;
MUL R1.xyz, R1, c[1];
MUL R0.xyz, R0, R1;
ADD R1.x, -R1.w, c[3];
MUL R0.w, R0, c[1];
MUL R0.w, R0, R1.x;
MUL result.color.xyz, R0, c[3].y;
MUL result.color.w, R0, c[3].y;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SOFTPARTICLES_ON" }
Vector 0 [_ZBufferParams]
Vector 1 [_TintColor]
Float 2 [_InvFade]
SetTexture 0 [_CameraDepthTexture] 2D
SetTexture 1 [_MainTex] 2D
"ps_2_0
; 13 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c3, 1.00000000, 2.00000000, 0, 0
dcl v0
dcl t0.xy
dcl t1
texldp r0, t1, s0
texld r1, t0, s1
mad r0.x, r0, c0.z, c0.w
rcp r0.x, r0.x
add r0.x, r0, -t1.z
mul_sat r0.x, r0, c2
mul_pp r0, v0, r0.x
mul_pp r1.xyz, r1, c1
mul_pp r1.xyz, r0, r1
add_pp r0.x, -r1.w, c3
mul_pp r2.x, r0.w, c1.w
mul r0.x, r2, r0
mul r1.xyz, r1, c3.y
mul r1.w, r0.x, c3.y
mov_pp oC0, r1
"
}

SubProgram "xbox360 " {
Keywords { "SOFTPARTICLES_ON" }
Float 2 [_InvFade]
Vector 1 [_TintColor]
Vector 0 [_ZBufferParams]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_CameraDepthTexture] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 13.33 (10 instructions), vertex: 0, texture: 8,
//   sequencer: 8, interpolator: 16;    4 GPRs, 48 threads,
// Performance (if enough threads): ~16 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabieaaaaaapeaaaaaaaaaaaaaaceaaaaabdaaaaaabfiaaaaaaaa
aaaaaaaaaaaaabaiaaaaaabmaaaaaapkppppadaaaaaaaaafaaaaaabmaaaaaaaa
aaaaaapdaaaaaaiaaaadaaabaaabaaaaaaaaaajeaaaaaaaaaaaaaakeaaacaaac
aaabaaaaaaaaaalaaaaaaaaaaaaaaamaaaadaaaaaaabaaaaaaaaaajeaaaaaaaa
aaaaaamjaaacaaabaaabaaaaaaaaaaneaaaaaaaaaaaaaaoeaaacaaaaaaabaaaa
aaaaaaneaaaaaaaafpedgbgngfhcgbeegfhahegifegfhihehfhcgfaaaaaeaaam
aaabaaabaaabaaaaaaaaaaaafpejgohgeggbgegfaaklklklaaaaaaadaaabaaab
aaabaaaaaaaaaaaafpengbgjgofegfhiaafpfegjgoheedgpgmgphcaaaaabaaad
aaabaaaeaaabaaaaaaaaaaaafpfkechfgggggfhcfagbhcgbgnhdaahahdfpddfp
daaadccodacodcdadddfddcodaaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaa
aaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaale
baaaadaaaaaaaaaiaaaaaaaaaaaacigdaaadaaahaaaaaaabaaaadafaaaaapbfb
aaaapckaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpiaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaafaeaacaaaabcaameaaaaaaaaaagaagcaambcaaccaaaaaaemiiacad
aablblblkbacababmiamacaaaablkmaaobacabaalibicaabbpbppbppaaaaeaaa
baaiaaabbpbppefiaaaaeaaamiaiacacaablmgblilacaaaaemihacadaabemabl
kbaaabacmiaiacacacblmgaaoaacabaabfibacaaaablgmlbkbacacaaaaboacaa
aagmpmgmobaaacaalibbacaaaablgmedobadacppbeaoacacaapmabgmobadaaaa
amihiaaaaabfbfgmoaacacacaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "SOFTPARTICLES_ON" }
Vector 0 [_ZBufferParams]
Vector 1 [_TintColor]
Float 2 [_InvFade]
SetTexture 0 [_CameraDepthTexture] 2D
SetTexture 1 [_MainTex] 2D
"sce_fp_rsx // 20 instructions using 2 registers
[Configuration]
24
ffffffff0000c0250003fffd000000000000840002000000
[Offsets]
3
_ZBufferParams 1 0
00000060
_TintColor 2 0
0000011000000090
_InvFade 1 0
000000e0
[Microcode]
320
b6021800c8011c9dc8000001c8003fe108000500a6041c9dc8020001c8000001
00013f7f00013b7f0001377f000000009e021702c8011c9dc8000001c8003fe1
3e800140c8011c9dc8000001c8003fe108000400c8001c9dc8020001fe020001
0000000000000000000000000000000008001a0054001c9dc8000001c8000001
0e840240c8041c9dc8020001c800000100000000000000000000000000000000
10820340c8041c9f00020000c800000100003f80000000000000000000000000
a8000300c8011c9fc8000001c8003fe108008200c8001c9d00020000c8000001
000000000000000000000000000000001e800200c9001c9d54000001c8000001
02820240ff001c9dfe020001c800000100000000000000000000000000000000
1080020001041c9cc9041001c80000010e810240c9001c9dc9081001c8000001
"
}

SubProgram "gles " {
Keywords { "SOFTPARTICLES_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SOFTPARTICLES_ON" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "SOFTPARTICLES_ON" }
Vector 0 [_ZBufferParams]
Vector 1 [_TintColor]
Float 2 [_InvFade]
SetTexture 0 [_CameraDepthTexture] 2D
SetTexture 1 [_MainTex] 2D
"agal_ps
c3 1.0 0.003922 0.000015 0.0
c4 2.0 0.0 0.0 0.0
[bc]
aeaaaaaaaaaaapacabaaaaoeaeaaaaaaabaaaappaeaaaaaa div r0, v1, v1.w
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaabaaaaaaafaababb tex r1, v0, s1 <2d wrap linear point>
bdaaaaaaaaaaabacaaaaaaoeacaaaaaaadaaaaoeabaaaaaa dp4 r0.x, r0, c3
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaakkabaaaaaa mul r0.x, r0.x, c0.z
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappabaaaaaa add r0.x, r0.x, c0.w
afaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, r0.x
acaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaakkaeaaaaaa sub r0.x, r0.x, v1.z
adaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaoeabaaaaaa mul r0.x, r0.x, c2
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
adaaaaaaaaaaapacahaaaaoeaeaaaaaaaaaaaaaaacaaaaaa mul r0, v7, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c1
adaaaaaaabaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r0.xyzz, r1.xyzz
bfaaaaaaacaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r2.w, r1.w
abaaaaaaaaaaabacacaaaappacaaaaaaadaaaaoeabaaaaaa add r0.x, r2.w, c3
adaaaaaaacaaabacaaaaaappacaaaaaaabaaaappabaaaaaa mul r2.x, r0.w, c1.w
adaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r2.x, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaaeaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c4.x
adaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa mul r1.w, r0.x, c4.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

}

#LINE 82
 
		}
	} 	

	// ---- Dual texture cards
	SubShader {
		Pass {
			SetTexture [_MainTex] {
				constantColor [_TintColor]
				combine constant * texture, constant * primary DOUBLE
			}
			SetTexture [_MainTex] {
				combine previous * primary DOUBLE, one - texture * previous
			}
		}
	}
	
	// ---- Single texture cards (does not do color tint)
	SubShader {
		Pass {
			SetTexture [_MainTex] {
				combine texture * primary DOUBLE, one - texture * primary
			}
		}
	}
}
}
