Shader "Custom/GroundFromSpace" {
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
Float 13 [_CameraHeight2]
Float 14 [_OuterRadius]
Float 15 [_OuterRadius2]
Float 16 [_InnerRadius]
Float 17 [_KrESun]
Float 18 [_KmESun]
Float 19 [_Kr4PI]
Float 20 [_Km4PI]
Float 21 [_Scale]
Float 22 [_ScaleDepth]
Float 23 [_InvScaleDepth]
Float 24 [_ScaleOverScaleDepth]
"!!ARBvp1.0
# 92 ALU
PARAM c[27] = { { 2.718282, 2, 4, 0 },
		state.matrix.mvp,
		program.local[5..24],
		{ 0.5, 1, 5.25, -6.8000002 },
		{ 3.8299999, 0.45899999, -0.00287 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, c[10];
ADD R2.xyz, -R0, c[9];
MOV R1.w, c[15].x;
ADD R2.w, -R1, c[13].x;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD R1.xyz, R0, -c[10];
ADD R0.xyz, R1, -R2;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R1.w, R0, R2;
MUL R1.w, R1, c[0].y;
MUL R2.w, R2, c[0].z;
MAD R2.w, R1, R1, -R2;
MAX R2.w, R2, c[0];
RSQ R2.w, R2.w;
RCP R2.w, R2.w;
ADD R1.w, -R1, -R2;
MUL R1.w, R1, c[25].x;
RCP R0.w, R0.w;
ADD R0.w, R0, -R1;
MAD R3.xyz, R0, R1.w, R2;
MUL R0.w, R0, c[25].x;
MUL R2.xyz, R0, R0.w;
MAD R3.xyz, R2, c[25].x, R3;
ADD R2.xyz, R3, R2;
DP3 R1.w, R2, R2;
RSQ R2.x, R1.w;
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R0.y, -R0, R1;
ADD R0.y, -R0, c[25];
DP3 R1.w, R3, R3;
RSQ R0.x, R1.w;
MAD R0.z, R0.y, c[25], c[25].w;
MAD R0.z, R0.y, R0, c[26].x;
MAD R0.z, R0.y, R0, c[26].y;
MAD R0.y, R0, R0.z, c[26].z;
POW R0.y, c[0].x, R0.y;
RCP R2.x, R2.x;
RCP R0.x, R0.x;
ADD R0.x, -R0, c[16];
MUL R0.x, R0, c[24];
POW R1.w, c[0].x, R0.x;
DP3 R0.x, R1, c[11];
MOV R1.x, c[14];
ADD R1.x, -R1, c[16];
MOV R2.w, c[17].x;
MUL R3.xyz, R2.w, c[12];
ADD R0.x, -R0, c[25].y;
MUL R0.z, R0.y, c[22].x;
MAD R0.y, R0.x, c[25].z, c[25].w;
MAD R0.y, R0.x, R0, c[26].x;
MAD R0.y, R0.x, R0, c[26];
MAD R0.x, R0, R0.y, c[26].z;
MUL R1.x, R1, c[23];
POW R0.y, c[0].x, R1.x;
POW R0.x, c[0].x, R0.x;
MAD R1.x, R0, c[22], R0.z;
MUL R1.y, R0.z, R0;
ADD R2.x, -R2, c[16];
MUL R0.y, R2.x, c[24].x;
MAD R2.y, R1.w, R1.x, -R1;
POW R2.x, c[0].x, R0.y;
MOV R0.x, c[19];
MUL R0.xyz, R0.x, c[12];
MAD R1.x, R1, R2, -R1.y;
ADD R0.xyz, R0, c[20].x;
MUL R1.xyz, R0, -R1.x;
MUL R0.xyz, -R2.y, R0;
MUL R0.w, R0, c[21].x;
MUL R2.x, R0.w, R2;
POW R1.x, c[0].x, R1.x;
POW R1.y, c[0].x, R1.y;
POW R1.z, c[0].x, R1.z;
MUL R2.xyz, R1, R2.x;
POW R0.x, c[0].x, R0.x;
POW R0.y, c[0].x, R0.y;
POW R0.z, c[0].x, R0.z;
MUL R0.w, R1, R0;
ADD R3.xyz, R3, c[18].x;
MAD R0.xyz, R0, R0.w, R2;
MUL result.color.xyz, R0, R3;
MOV result.color.secondary.xyz, R1;
MOV result.texcoord[1].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 92 instructions, 4 R-regs
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
Float 12 [_CameraHeight2]
Float 13 [_OuterRadius]
Float 14 [_OuterRadius2]
Float 15 [_InnerRadius]
Float 16 [_KrESun]
Float 17 [_KmESun]
Float 18 [_Kr4PI]
Float 19 [_Km4PI]
Float 20 [_Scale]
Float 21 [_ScaleDepth]
Float 22 [_InvScaleDepth]
Float 23 [_ScaleOverScaleDepth]
"vs_2_0
; 124 ALU
def c24, 2.00000000, 4.00000000, 0.00000000, 0.50000000
def c25, 2.71828198, 1.00000000, 5.25000000, -6.80000019
def c26, 3.82999992, 0.45899999, -0.00287000, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.xyz, c8
add r2.xyz, -c9, r0
mov r1.w, c12.x
add r2.w, -c14.x, r1
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r1.xyz, r0, -c9
add r0.xyz, r1, -r2
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r1.w, r0, r2
mul r1.w, r1, c24.x
mul r2.w, r2, c24.y
mad r2.w, r1, r1, -r2
max r2.w, r2, c24.z
rsq r2.w, r2.w
rcp r2.w, r2.w
add r1.w, -r1, -r2
mul r1.w, r1, c24
rcp r0.w, r0.w
add r0.w, r0, -r1
mad r3.xyz, r0, r1.w, r2
mul r4.w, r0, c24
mul r2.xyz, r0, r4.w
mad r3.xyz, r2, c24.w, r3
dp3 r0.w, r3, r3
rsq r0.w, r0.w
rcp r0.w, r0.w
add r0.w, -r0, c15.x
dp3 r2.w, r1, r1
mul r1.w, r0, c23.x
rsq r0.w, r2.w
mul r1.xyz, r0.w, r1
dp3 r0.x, -r0, r1
add r2.xyz, r3, r2
dp3 r0.w, r2, r2
rsq r0.y, r0.w
rcp r0.z, r0.y
add r0.x, -r0, c25.y
mad r0.y, r0.x, c25.z, c25.w
mad r0.y, r0.x, r0, c26.x
add r0.z, -r0, c15.x
mul r0.z, r0, c23.x
pow r2, c25.x, r0.z
mad r0.y, r0.x, r0, c26
mad r2.y, r0.x, r0, c26.z
pow r0, c25.x, r2.y
dp3 r0.y, r1, c10
mov r0.z, r0.x
add r0.x, -r0.y, c25.y
mul r1.x, r0.z, c21
mad r0.y, r0.x, c25.z, c25.w
mad r0.y, r0.x, r0, c26.x
mad r0.y, r0.x, r0, c26
mov r0.z, c15.x
add r0.z, -c13.x, r0
mov r5.x, r2
mad r1.y, r0.x, r0, c26.z
pow r2, c25.x, r1.y
mul r1.z, r0, c22.x
pow r0, c25.x, r1.z
mov r0.y, r0.x
mov r0.x, r2
mul r2.y, r1.x, r0
mad r2.z, r0.x, c21.x, r1.x
pow r0, c25.x, r1.w
mov r1.w, r0.x
mov r1.xyz, c11
mul r1.xyz, c18.x, r1
add r0.xyz, r1, c19.x
mad r0.w, r1, r2.z, -r2.y
mad r2.x, r2.z, r5, -r2.y
mul r1.xyz, r0, -r2.x
mul r4.xyz, -r0.w, r0
pow r2, c25.x, r1.x
pow r3, c25.x, r1.y
mov r1.x, r2
pow r2, c25.x, r1.z
mul r2.w, r4, c20.x
pow r0, c25.x, r4.x
mul r0.y, r2.w, r5.x
mov r1.y, r3
mov r1.z, r2
pow r3, c25.x, r4.y
mov r3.x, r0
mul r2.xyz, r1, r0.y
pow r0, c25.x, r4.z
mov r3.z, r0
mov r4.xyz, c11
mul r0.xyz, c16.x, r4
mul r0.w, r1, r2
add r0.xyz, r0, c17.x
mad r2.xyz, r3, r0.w, r2
mul oD0.xyz, r2, r0
mov oD1.xyz, r1
mov oT1.xy, v1
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
TEX R0.xyz, fragment.texcoord[1], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[1], 2D;
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
dcl t1.xy
texld r0, t1, s1
texld r1, t1, s0
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