Shader "Custom/SkyFromSpace" {
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
}
SubShader { 
 Tags { "QUEUE"="Transparent" }
 Pass {
  Tags { "QUEUE"="Transparent" }
  ZWrite Off
  Cull Front
  Blend One One
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
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
# 111 ALU
PARAM c[27] = { { 2.718282, 2, 4, 0 },
		state.matrix.mvp,
		program.local[5..24],
		{ 0.5, 1, 5.25, -6.8000002 },
		{ 3.8299999, 0.45899999, -0.00287 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MOV R1.w, c[15].x;
ADD R2.w, -R1, c[13].x;
MOV R0.xyz, c[10];
ADD R0.xyz, -R0, c[9];
DP4 R1.z, vertex.position, c[7];
DP4 R1.x, vertex.position, c[5];
DP4 R1.y, vertex.position, c[6];
ADD R1.xyz, R1, -c[10];
ADD R1.xyz, R1, -R0;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R1;
DP3 R1.w, R2, R0;
MUL R1.w, R1, c[0].y;
MUL R2.w, R2, c[0].z;
MAD R2.w, R1, R1, -R2;
MAX R2.w, R2, c[0];
RSQ R2.w, R2.w;
RCP R2.w, R2.w;
ADD R1.w, -R1, -R2;
MUL R2.w, R1, c[25].x;
RCP R0.w, R0.w;
ADD R0.w, R0, -R2;
MAD R3.xyz, R2, R2.w, R0;
MUL R1.w, R0, c[25].x;
MUL R0.xyz, R2, R1.w;
MAD R4.xyz, R0, c[25].x, R3;
DP3 R0.w, R4, R4;
DP3 R3.x, R2, R3;
ADD R0.xyz, R4, R0;
DP3 R2.w, R4, R2;
DP3 R2.y, R2, R0;
DP3 R2.x, R0, R0;
DP3 R0.y, R0, c[11];
RSQ R0.x, R2.x;
MAD R2.x, R0, -R2.y, c[25].y;
MAD R0.y, R0.x, -R0, c[25];
RSQ R0.w, R0.w;
MAD R2.w, R0, -R2, c[25].y;
MAD R5.x, R2.w, c[25].z, c[25].w;
MAD R5.x, R2.w, R5, c[26];
MAD R5.x, R2.w, R5, c[26].y;
MAD R0.z, R0.y, c[25], c[25].w;
MAD R2.y, R2.x, c[25].z, c[25].w;
MAD R0.z, R0.y, R0, c[26].x;
MAD R0.z, R0.y, R0, c[26].y;
MAD R0.y, R0, R0.z, c[26].z;
MAD R2.y, R2.x, R2, c[26].x;
MAD R2.y, R2.x, R2, c[26];
MAD R0.z, R2.x, R2.y, c[26];
DP3 R3.w, R4, c[11];
MAD R3.w, R0, -R3, c[25].y;
MAD R4.w, R3, c[25].z, c[25];
MAD R4.w, R3, R4, c[26].x;
RCP R0.w, R0.w;
ADD R0.w, -R0, c[16].x;
MUL R0.w, R0, c[24].x;
POW R0.z, c[0].x, R0.z;
RCP R0.x, R0.x;
MAD R4.w, R3, R4, c[26].y;
MAD R5.x, R2.w, R5, c[26].z;
MAD R2.w, R3, R4, c[26].z;
POW R3.w, c[0].x, R5.x;
RCP R4.w, c[14].x;
MAD R3.x, -R3, R4.w, c[25].y;
MAD R3.y, R3.x, c[25].z, c[25].w;
MAD R3.y, R3.x, R3, c[26].x;
MAD R3.y, R3.x, R3, c[26];
MAD R3.x, R3, R3.y, c[26].z;
POW R3.y, c[0].x, R3.x;
MOV R3.x, c[23];
MUL R3.y, R3, c[22].x;
POW R3.x, c[0].x, -R3.x;
MUL R3.x, R3, R3.y;
POW R0.w, c[0].x, R0.w;
POW R0.y, c[0].x, R0.y;
MUL R0.z, R0, c[22].x;
MAD R2.x, R0.y, c[22], -R0.z;
ADD R0.x, -R0, c[16];
MUL R0.y, R0.x, c[24].x;
POW R3.y, c[0].x, R0.y;
MOV R0.x, c[19];
MUL R0.xyz, R0.x, c[12];
MAD R2.x, R3.y, R2, R3;
ADD R0.xyz, R0, c[20].x;
MUL R2.xyz, R0, -R2.x;
MUL R1.w, R1, c[21].x;
POW R2.w, c[0].x, R2.w;
MUL R3.w, R3, c[22].x;
MAD R2.w, R2, c[22].x, -R3;
MAD R2.w, R0, R2, R3.x;
MUL R0.xyz, -R2.w, R0;
MUL R2.w, R1, R3.y;
POW R2.x, c[0].x, R2.x;
POW R2.y, c[0].x, R2.y;
POW R2.z, c[0].x, R2.z;
MUL R2.xyz, R2, R2.w;
MOV R2.w, c[17].x;
POW R0.x, c[0].x, R0.x;
POW R0.y, c[0].x, R0.y;
POW R0.z, c[0].x, R0.z;
MUL R0.w, R0, R1;
MAD R0.xyz, R0, R0.w, R2;
MUL R3.xyz, R2.w, c[12];
MUL result.color.xyz, R0, R3;
MUL result.color.secondary.xyz, R0, c[18].x;
MOV result.texcoord[0].xyz, -R1;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 111 instructions, 6 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
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
; 151 ALU
def c24, 2.00000000, 4.00000000, 0.00000000, 0.50000000
def c25, 2.71828198, 1.00000000, 5.25000000, -6.80000019
def c26, 3.82999992, 0.45899999, -0.00287000, 0
dcl_position0 v0
mov r1.w, c12.x
add r2.w, -c14.x, r1
mov r0.xyz, c8
add r0.xyz, -c9, r0
dp4 r1.z, v0, c6
dp4 r1.x, v0, c4
dp4 r1.y, v0, c5
add r1.xyz, r1, -c9
add r1.xyz, r1, -r0
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r2.xyz, r0.w, r1
dp3 r1.w, r2, r0
mul r1.w, r1, c24.x
mul r2.w, r2, c24.y
mad r2.w, r1, r1, -r2
max r2.w, r2, c24.z
rsq r2.w, r2.w
rcp r2.w, r2.w
add r1.w, -r1, -r2
mul r2.w, r1, c24
rcp r0.w, r0.w
add r0.w, r0, -r2
mul r1.w, r0, c24
mul r4.xyz, r2, r1.w
mad r5.xyz, r2, r2.w, r0
mad r6.xyz, r4, c24.w, r5
dp3 r0.x, r6, r6
dp3 r0.z, r6, r2
rsq r2.w, r0.x
mad r0.z, r2.w, -r0, c25.y
dp3 r0.y, r6, c10
mad r0.x, r2.w, -r0.y, c25.y
mad r0.w, r0.z, c25.z, c25
mad r0.y, r0.x, c25.z, c25.w
mad r0.w, r0.z, r0, c26.x
mad r0.y, r0.x, r0, c26.x
mad r0.w, r0.z, r0, c26.y
mad r0.y, r0.x, r0, c26
mad r3.x, r0.z, r0.w, c26.z
mad r4.w, r0.x, r0.y, c26.z
pow r0, c25.x, r3.x
pow r3, c25.x, r4.w
mov r0.y, r0.x
mov r0.x, r3
add r3.xyz, r6, r4
mul r0.y, r0, c21.x
mad r3.w, r0.x, c21.x, -r0.y
dp3 r0.x, r2, r5
rcp r0.y, c13.x
mad r0.y, -r0.x, r0, c25
rcp r0.x, r2.w
mad r0.z, r0.y, c25, c25.w
mad r0.z, r0.y, r0, c26.x
mad r0.z, r0.y, r0, c26.y
add r0.x, -r0, c15
mul r0.x, r0, c23
pow r5, c25.x, r0.x
mad r2.w, r0.y, r0.z, c26.z
pow r0, c25.x, r2.w
mov r0.y, c22.x
pow r4, c25.x, -r0.y
dp3 r6.x, r3, r3
dp3 r2.y, r2, r3
mul r0.y, r0.x, c21.x
mov r0.x, r4
mul r0.w, r0.x, r0.y
mov r4.w, r5.x
mad r4.x, r4.w, r3.w, r0.w
mov r0.xyz, c11
mul r0.xyz, c18.x, r0
add r0.xyz, r0, c19.x
mul r4.xyz, -r4.x, r0
rsq r3.w, r6.x
dp3 r2.w, r3, c10
mad r3.y, r3.w, -r2, c25
mad r2.w, r3, -r2, c25.y
mad r5.x, r2.w, c25.z, c25.w
mad r5.x, r2.w, r5, c26
mad r2.x, r2.w, r5, c26.y
mad r3.x, r2.w, r2, c26.z
pow r2, c25.x, r3.x
mad r3.z, r3.y, c25, c25.w
mad r2.y, r3, r3.z, c26.x
mad r2.y, r3, r2, c26
mad r3.z, r3.y, r2.y, c26
mov r3.x, r2
pow r2, c25.x, r3.z
rcp r3.y, r3.w
add r2.y, -r3, c15.x
mul r3.y, r2, c23.x
mov r3.z, r2.x
pow r2, c25.x, r3.y
mul r2.y, r3.z, c21.x
mad r2.y, r3.x, c21.x, -r2
mov r5.w, r2.x
mad r0.w, r5, r2.y, r0
mul r5.xyz, r0, -r0.w
pow r2, c25.x, r4.x
pow r3, c25.x, r5.x
pow r0, c25.x, r5.y
mov r4.x, r2
pow r2, c25.x, r4.z
mov r3.y, r0
pow r0, c25.x, r5.z
mul r1.w, r1, c20.x
mul r0.x, r1.w, r5.w
mov r3.z, r0
mul r3.xyz, r3, r0.x
pow r0, c25.x, r4.y
mov r4.y, r0
mov r0.xyz, c11
mov r4.z, r2
mul r0.w, r4, r1
mad r2.xyz, r4, r0.w, r3
mul r0.xyz, c16.x, r0
mul oD0.xyz, r2, r0
mul oD1.xyz, r2, c17.x
mov oT0.xyz, -r1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_LightDir]
Float 1 [_GValue]
Float 2 [_GValue2]
"!!ARBfp1.0
# 23 ALU, 0 TEX
PARAM c[4] = { program.local[0..2],
		{ 1, 2, 1.5, 0.75 } };
TEMP R0;
DP3 R0.y, fragment.texcoord[0], fragment.texcoord[0];
DP3 R0.x, fragment.texcoord[0], c[0];
RSQ R0.y, R0.y;
MUL R0.z, R0.y, R0.x;
MOV R0.xy, c[3];
MUL R0.w, R0.z, c[1].x;
MUL R0.w, -R0, c[3].y;
ADD R0.y, R0, c[2].x;
ADD R0.w, R0, c[2].x;
RCP R0.y, R0.y;
ADD R0.x, R0, -c[2];
MUL R0.x, R0, R0.y;
MUL R0.y, R0.z, R0.z;
ADD R0.w, R0, c[3].x;
POW R0.z, R0.w, c[3].z;
ADD R0.w, R0.y, c[3].x;
MUL R0.x, R0, R0.w;
RCP R0.z, R0.z;
MUL R0.x, R0, R0.z;
MUL R0.xzw, R0.x, fragment.color.secondary.xyyz;
MUL R0.xzw, R0, c[3].z;
MAD R0.y, R0, c[3].w, c[3].w;
MAD result.color, R0.y, fragment.color.primary.xyzz, R0.xzww;
END
# 23 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_LightDir]
Float 1 [_GValue]
Float 2 [_GValue2]
"ps_2_0
; 29 ALU
def c3, 2.00000000, 1.00000000, 1.50000000, 0.75000000
dcl v0.xyz
dcl v1.xyz
dcl t0.xyz
mov r3.x, c2
add r4.x, c3, r3
dp3 r1.x, t0, t0
mov r3.x, c2
rsq r1.x, r1.x
dp3 r0.x, t0, c0
mul r0.x, r1, r0
mul r1.x, r0, c1
mul r1.x, -r1, c3
add r1.x, r1, c2
add r1.x, r1, c3.y
pow r2.x, r1.x, c3.z
mov r1.x, r2.x
mul r0.x, r0, r0
add r2.x, r0, c3.y
rcp r1.x, r1.x
rcp r4.x, r4.x
add r3.x, c3.y, -r3
mul r3.x, r3, r4
mul r2.x, r3, r2
mul r1.x, r2, r1
mul r1.xyz, r1.x, v1
mul r1.xyz, r1, c3.z
mad r0.x, r0, c3.w, c3.w
mad r0.xyz, r0.x, v0, r1
mov r0.w, r0.z
mov_pp oC0, r0
"
}
}
 }
}
Fallback "Diffuse"
}