Shader "Custom/GroundFromAtmosphere" {
Properties {
 _CameraPos ("Camera position", Vector) = (20,20,0,1)
 _SpherePos ("Sphere position (center)", Vector) = (0,0,0,1)
 _LightDir ("Light direction", Vector) = (0,1,0,0)
 _InvWavelength ("Light wavelength inverses for R, G and B channels", Vector) = (0.0001,0.0001,0.0001,0)
 _CameraHeight ("Camera height over ground", Float) = 10
 _CameraHeight2 ("Camera height over ground ^ 2", Float) = 100
 _OuterRadius ("Atmosphere radius", Float) = 5.15
 _OuterRadius2 ("Atmosphere radius ^ 2", Float) = 26.5225
 _InnerRadius ("Planet radius", Float) = 5
 _InnerRadius2 ("Planet radius ^ 2", Float) = 25
 _KrESun ("Kr * ESun", Float) = 0.0375
 _KmESun ("Km * ESun", Float) = 0.0225
 _Kr4PI ("Kr * 4 * PI", Float) = 0.0314
 _Km4PI ("Km * 4 * PI", Float) = 0.01884
 _Scale ("Scale: 1 / (AtmRadius - PlanetRadius)", Float) = 6.66
 _ScaleDepth ("Scale depth: altitude with atmosphere's average density", Float) = 0.25
 _InvScaleDepth ("1.0 / _ScaleDepth", Float) = 4
 _ScaleOverScaleDepth ("Scale / ScaleDepth", Float) = 26.66
 _NumSamples ("Number of samples", Float) = 2
 _GValue ("G value", Float) = -0.95
 _GValue2 ("G value ^ 2", Float) = 0.9025
 _MainTex ("Planet texture", 2D) = "black" {}
 _NightTex ("Planet night texture", 2D) = "black" {}
}
SubShader { 
 Pass {
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [_CameraPos]
Vector 10 [_SpherePos]
Vector 11 [_LightDir]
Vector 12 [_InvWavelength]
Float 13 [_OuterRadius]
Float 14 [_InnerRadius]
Float 15 [_KrESun]
Float 16 [_KmESun]
Float 17 [_Kr4PI]
Float 18 [_Km4PI]
Float 19 [_Scale]
Float 20 [_ScaleDepth]
Float 21 [_InvScaleDepth]
Float 22 [_ScaleOverScaleDepth]
"!!ARBvp1.0
# 80 ALU
PARAM c[24] = { { 2.718282, 0.5, 1, 5.25 },
		state.matrix.mvp,
		program.local[5..22],
		{ -6.8000002, 3.8299999, 0.45899999, -0.00287 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, c[10];
ADD R0.xyz, -R0, c[9];
DP4 R1.z, vertex.position, c[7];
DP4 R1.x, vertex.position, c[5];
DP4 R1.y, vertex.position, c[6];
ADD R1.xyz, R1, -c[10];
ADD R2.xyz, R1, -R0;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
RCP R0.w, R1.w;
MUL R2.xyz, R1.w, R2;
MUL R0.w, R0, c[0].y;
MUL R3.xyz, R2, R0.w;
MAD R0.xyz, R3, c[0].y, R0;
ADD R3.xyz, R0, R3;
DP3 R1.w, R3, R3;
RSQ R2.w, R1.w;
DP3 R2.x, -R2, R1;
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MAD R2.y, R1.w, -R2.x, c[0].z;
DP3 R1.x, R1, c[11];
MAD R1.y, -R1.x, R1.w, c[0].z;
RCP R2.z, R2.w;
MUL R2.x, R2.y, c[0].w;
ADD R2.z, -R2, c[14].x;
MOV R1.w, c[13].x;
ADD R1.w, -R1, c[14].x;
MUL R2.w, R2.z, c[22].x;
ADD R2.x, R2, c[23];
MAD R2.z, R2.y, R2.x, c[23].y;
POW R2.x, c[0].x, R2.w;
MAD R2.z, R2.y, R2, c[23];
MAD R1.z, R2.y, R2, c[23].w;
POW R1.x, c[0].x, R1.z;
MUL R1.z, R1.y, c[0].w;
ADD R1.z, R1, c[23].x;
MAD R1.z, R1.y, R1, c[23].y;
MAD R1.z, R1.y, R1, c[23];
MAD R1.y, R1, R1.z, c[23].w;
MUL R1.w, R1, c[21].x;
MOV R2.w, c[15].x;
MUL R3.xyz, R2.w, c[12];
MUL R1.x, R1, c[20];
POW R1.z, c[0].x, R1.w;
MUL R2.z, R1.x, R1;
POW R1.y, c[0].x, R1.y;
MAD R2.y, R1, c[20].x, R1.x;
DP3 R1.y, R0, R0;
MOV R1.z, c[17].x;
MUL R0.xyz, R1.z, c[12];
RSQ R1.w, R1.y;
RCP R1.w, R1.w;
ADD R1.w, -R1, c[14].x;
MUL R1.w, R1, c[22].x;
MAD R1.x, R2.y, R2, -R2.z;
ADD R0.xyz, R0, c[18].x;
MUL R1.xyz, R0, -R1.x;
POW R1.w, c[0].x, R1.w;
MUL R0.w, R0, c[19].x;
MAD R2.y, R1.w, R2, -R2.z;
MUL R0.xyz, -R2.y, R0;
MUL R2.x, R0.w, R2;
POW R1.x, c[0].x, R1.x;
POW R1.y, c[0].x, R1.y;
POW R1.z, c[0].x, R1.z;
MUL R2.xyz, R1, R2.x;
POW R0.x, c[0].x, R0.x;
POW R0.y, c[0].x, R0.y;
POW R0.z, c[0].x, R0.z;
MUL R0.w, R1, R0;
ADD R3.xyz, R3, c[16].x;
MAD R0.xyz, R0, R0.w, R2;
MUL result.color.xyz, R0, R3;
MOV result.color.secondary.xyz, R1;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 80 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [_CameraPos]
Vector 9 [_SpherePos]
Vector 10 [_LightDir]
Vector 11 [_InvWavelength]
Float 12 [_OuterRadius]
Float 13 [_InnerRadius]
Float 14 [_KrESun]
Float 15 [_KmESun]
Float 16 [_Kr4PI]
Float 17 [_Km4PI]
Float 18 [_Scale]
Float 19 [_ScaleDepth]
Float 20 [_InvScaleDepth]
Float 21 [_ScaleOverScaleDepth]
"vs_2_0
; 109 ALU
def c22, 0.50000000, 2.71828198, 1.00000000, 3.82999992
def c23, 5.25000000, -6.80000019, 0.45899999, -0.00287000
dcl_position0 v0
dcl_texcoord0 v1
mov r0.xyz, c8
add r3.xyz, -c9, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r1.xyz, r0, -c9
add r0.xyz, r1, -r3
dp3 r0.w, r0, r0
rsq r0.w, r0.w
rcp r1.w, r0.w
mul r0.xyz, r0.w, r0
mul r4.x, r1.w, c22
mul r2.xyz, r0, r4.x
mad r3.xyz, r2, c22.x, r3
add r2.xyz, r3, r2
dp3 r0.w, r2, r2
rsq r0.w, r0.w
rcp r0.w, r0.w
add r2.y, -r0.w, c13.x
dp3 r0.w, r1, r1
dp3 r0.x, -r0, r1
rsq r2.x, r0.w
mad r1.w, r2.x, -r0.x, c22.z
mul r2.z, r2.y, c21.x
pow r0, c22.y, r2.z
mad r2.y, r1.w, c23.x, c23
mad r0.y, r1.w, r2, c22.w
mov r0.w, r0.x
mad r0.y, r1.w, r0, c23.z
dp3 r0.x, r1, c10
mad r0.y, r1.w, r0, c23.w
pow r1, c22.y, r0.y
mad r0.x, -r0, r2, c22.z
mov r0.z, r1.x
mul r3.w, r0.z, c19.x
mad r0.y, r0.x, c23.x, c23
mad r0.y, r0.x, r0, c22.w
mad r0.y, r0.x, r0, c23.z
mad r0.x, r0, r0.y, c23.w
pow r2, c22.y, r0.x
mov r0.z, c13.x
add r0.y, -c12.x, r0.z
mul r0.x, r0.y, c20
pow r1, c22.y, r0.x
mov r0.x, r2
mad r4.y, r0.x, c19.x, r3.w
mul r4.z, r3.w, r1.x
mov r0.xyz, c11
mul r0.xyz, c16.x, r0
mad r1.x, r4.y, r0.w, -r4.z
add r0.xyz, r0, c17.x
mul r1.xyz, r0, -r1.x
pow r2, c22.y, r1.x
dp3 r1.x, r3, r3
rsq r1.w, r1.x
mov r1.x, r2
pow r2, c22.y, r1.y
rcp r1.w, r1.w
add r1.y, -r1.w, c13.x
mul r1.w, r1.y, c21.x
pow r3, c22.y, r1.w
mov r1.y, r2
pow r2, c22.y, r1.z
mov r1.z, r2
mov r1.w, r3.x
mad r2.x, r1.w, r4.y, -r4.z
mul r2.w, r4.x, c18.x
mul r4.xyz, -r2.x, r0
mul r2.x, r2.w, r0.w
pow r0, c22.y, r4.x
pow r3, c22.y, r4.y
mov r3.x, r0
pow r0, c22.y, r4.z
mov r3.z, r0
mov r4.xyz, c11
mul r0.xyz, c14.x, r4
mul r2.xyz, r1, r2.x
mul r0.w, r1, r2
add r0.xyz, r0, c15.x
mad r2.xyz, r3, r0.w, r2
mul oD0.xyz, r2, r0
mov oD1.xyz, r1
mov oT0.xy, v1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NightTex] 2D
"!!ARBfp1.0
# 11 ALU, 2 TEX
PARAM c[1] = { { 1, 0.75 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[0], texture[1], 2D;
ADD R2.xyz, -fragment.color.secondary, c[0].x;
MUL R2.xyz, R2, R2;
MUL R2.xyz, R2, R2;
MUL R0.xyz, fragment.color.secondary, R0;
MUL R2.xyz, R2, R2;
ADD R0.xyz, R0, fragment.color.primary;
MUL R1.xyz, R1, R2;
MAD result.color.xyz, R1, c[0].y, R0;
MOV result.color.w, c[0].x;
END
# 11 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NightTex] 2D
"ps_2_0
; 10 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c0, 1.00000000, 0.75000000, 0, 0
dcl v0.xyz
dcl v1.xyz
dcl t0.xy
texld r0, t0, s1
texld r1, t0, s0
add r2.xyz, -v1, c0.x
mul r2.xyz, r2, r2
mul r2.xyz, r2, r2
mul r1.xyz, v1, r1
mul r2.xyz, r2, r2
mul r0.xyz, r0, r2
add r1.xyz, r1, v0
mov r0.w, c0.x
mad r0.xyz, r0, c0.y, r1
mov_pp oC0, r0
"
}
}
 }
}
Fallback "Diffuse"
}