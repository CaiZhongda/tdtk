Shader "Custom/SkyFromAtmosphere" {
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
Float 13 [_CameraHeight]
Float 14 [_InnerRadius]
Float 15 [_KrESun]
Float 16 [_KmESun]
Float 17 [_Kr4PI]
Float 18 [_Km4PI]
Float 19 [_Scale]
Float 20 [_ScaleDepth]
Float 21 [_ScaleOverScaleDepth]
"!!ARBvp1.0
# 106 ALU
PARAM c[23] = { { 2.718282, 0.5, 1, 5.25 },
		state.matrix.mvp,
		program.local[5..21],
		{ -6.8000002, 3.8299999, 0.45899999, -0.00287 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.xyz, c[10];
ADD R1.xyz, -R0, c[9];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD R0.xyz, R0, -c[10];
ADD R0.xyz, R0, -R1;
DP3 R0.w, R0, R0;
RSQ R1.w, R0.w;
RCP R0.w, R1.w;
MUL R2.xyz, R1.w, R0;
MUL R0.w, R0, c[0].y;
MUL R3.xyz, R2, R0.w;
MAD R4.xyz, R3, c[0].y, R1;
ADD R3.xyz, R4, R3;
DP3 R1.w, R3, R3;
DP3 R2.w, R2, R3;
RSQ R1.w, R1.w;
DP3 R3.x, R3, c[11];
MAD R2.w, R1, -R2, c[0].z;
MAD R3.x, R1.w, -R3, c[0].z;
MUL R3.y, R3.x, c[0].w;
MUL R3.z, R2.w, c[0].w;
ADD R3.y, R3, c[22].x;
MAD R3.y, R3.x, R3, c[22];
MAD R3.y, R3.x, R3, c[22].z;
ADD R3.z, R3, c[22].x;
MAD R3.z, R2.w, R3, c[22].y;
MAD R3.x, R3, R3.y, c[22].w;
MAD R3.z, R2.w, R3, c[22];
MAD R3.y, R2.w, R3.z, c[22].w;
POW R2.w, c[0].x, R3.x;
DP3 R3.x, R1, R1;
DP3 R1.x, R2, R1;
RSQ R3.x, R3.x;
MAD R1.x, -R1, R3, c[0].z;
MUL R1.y, R1.x, c[0].w;
RCP R1.z, R1.w;
POW R3.y, c[0].x, R3.y;
MUL R3.y, R3, c[20].x;
ADD R1.y, R1, c[22].x;
MAD R1.y, R1.x, R1, c[22];
MAD R1.y, R1.x, R1, c[22].z;
MAD R1.y, R1.x, R1, c[22].w;
ADD R1.z, -R1, c[14].x;
MOV R1.x, c[13];
POW R1.y, c[0].x, R1.y;
ADD R1.x, -R1, c[14];
MUL R1.x, R1, c[21];
DP3 R2.y, R4, R2;
DP3 R3.w, R4, R4;
RSQ R2.x, R3.w;
MAD R2.y, R2.x, -R2, c[0].z;
MUL R2.z, R2.y, c[0].w;
ADD R3.w, R2.z, c[22].x;
DP3 R2.z, R4, c[11];
MAD R2.z, R2.x, -R2, c[0];
MAD R3.w, R2.y, R3, c[22].y;
MAD R4.x, R2.y, R3.w, c[22].z;
MAD R4.x, R2.y, R4, c[22].w;
MUL R3.w, R2.z, c[0];
ADD R2.y, R3.w, c[22].x;
MAD R3.w, R2.z, R2.y, c[22].y;
MAD R3.w, R2.z, R3, c[22].z;
MAD R2.z, R2, R3.w, c[22].w;
POW R4.x, c[0].x, R4.x;
RCP R2.x, R2.x;
ADD R2.x, -R2, c[14];
MUL R2.x, R2, c[21];
MAD R3.x, R2.w, c[20], -R3.y;
MUL R1.z, R1, c[21].x;
POW R2.w, c[0].x, R1.z;
POW R3.w, c[0].x, R2.x;
MUL R0.w, R0, c[19].x;
MUL R2.x, R0.w, R2.w;
MUL R1.y, R1, c[20].x;
POW R1.x, c[0].x, R1.x;
MUL R1.w, R1.x, R1.y;
MOV R1.z, c[17].x;
MUL R1.xyz, R1.z, c[12];
MAD R3.x, R2.w, R3, R1.w;
ADD R1.xyz, R1, c[18].x;
MUL R3.xyz, R1, -R3.x;
POW R3.x, c[0].x, R3.x;
POW R3.y, c[0].x, R3.y;
POW R3.z, c[0].x, R3.z;
POW R2.z, c[0].x, R2.z;
MUL R2.y, R4.x, c[20].x;
MAD R2.y, R2.z, c[20].x, -R2;
MAD R1.w, R3, R2.y, R1;
MUL R1.xyz, -R1.w, R1;
MUL R2.xyz, R3, R2.x;
MOV R1.w, c[15].x;
POW R1.x, c[0].x, R1.x;
POW R1.y, c[0].x, R1.y;
POW R1.z, c[0].x, R1.z;
MUL R0.w, R3, R0;
MAD R1.xyz, R1, R0.w, R2;
MUL R3.xyz, R1.w, c[12];
MUL result.color.xyz, R1, R3;
MUL result.color.secondary.xyz, R1, c[16].x;
MOV result.texcoord[0].xyz, -R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 106 instructions, 5 R-regs
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
Float 12 [_CameraHeight]
Float 13 [_InnerRadius]
Float 14 [_KrESun]
Float 15 [_KmESun]
Float 16 [_Kr4PI]
Float 17 [_Km4PI]
Float 18 [_Scale]
Float 19 [_ScaleDepth]
Float 20 [_ScaleOverScaleDepth]
"vs_2_0
; 140 ALU
def c21, 0.50000000, 2.71828198, 1.00000000, 3.82999992
def c22, 5.25000000, -6.80000019, 0.45899999, -0.00287000
dcl_position0 v0
mov r0.xyz, c8
add r5.xyz, -c9, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r0.xyz, r0, -c9
add r1.xyz, r0, -r5
dp3 r0.x, r1, r1
rsq r0.x, r0.x
rcp r0.y, r0.x
mul r2.xyz, r0.x, r1
mul r1.w, r0.y, c21.x
mul r0.xyz, r2, r1.w
mad r3.xyz, r0, c21.x, r5
add r0.xyz, r3, r0
dp3 r0.w, r0, r0
dp3 r3.w, r0, c10
dp3 r0.x, r2, r0
rsq r2.w, r0.w
mad r0.z, r2.w, -r0.x, c21
mad r0.x, r2.w, -r3.w, c21.z
mad r0.w, r0.z, c22.x, c22.y
mad r0.y, r0.x, c22.x, c22
mad r0.w, r0.z, r0, c21
mad r0.y, r0.x, r0, c21.w
mad r0.w, r0.z, r0, c22.z
mad r0.y, r0.x, r0, c22.z
mad r4.x, r0.z, r0.w, c22.w
mad r3.w, r0.x, r0.y, c22
pow r0, c21.y, r4.x
pow r4, c21.y, r3.w
mul r0.z, r0.x, c19.x
mov r0.y, r4.x
rcp r0.x, r2.w
mad r2.w, r0.y, c19.x, -r0.z
add r0.y, -r0.x, c13.x
dp3 r0.x, r5, r5
mul r4.x, r0.y, c20
rsq r0.y, r0.x
dp3 r0.x, r2, r5
mad r3.w, -r0.x, r0.y, c21.z
pow r0, c21.y, r4.x
mad r0.y, r3.w, c22.x, c22
mov r5.w, r0.x
mad r0.y, r3.w, r0, c21.w
mad r0.y, r3.w, r0, c22.z
mad r4.x, r3.w, r0.y, c22.w
mov r0.x, c13
add r3.w, -c12.x, r0.x
pow r0, c21.y, r4.x
mul r0.y, r3.w, c20.x
pow r4, c21.y, r0.y
mul r3.w, r0.x, c19.x
mov r0.w, r4.x
mul r4.w, r0, r3
mov r0.xyz, c11
mul r0.xyz, c16.x, r0
mad r0.w, r5, r2, r4
add r4.xyz, r0, c17.x
mul r5.xyz, r4, -r0.w
pow r0, c21.y, r5.x
mov r5.x, r0
pow r0, c21.y, r5.y
dp3 r0.x, r3, r3
dp3 r0.z, r3, r2
rsq r3.w, r0.x
mad r2.x, r3.w, -r0.z, c21.z
mad r0.x, r2, c22, c22.y
mad r2.y, r2.x, r0.x, c21.w
mov r5.y, r0
pow r0, c21.y, r5.z
mad r0.x, r2, r2.y, c22.z
mad r0.y, r2.x, r0.x, c22.w
dp3 r0.x, r3, c10
mad r0.w, r3, -r0.x, c21.z
pow r2, c21.y, r0.y
mad r0.x, r0.w, c22, c22.y
mad r0.y, r0.w, r0.x, c21.w
mul r0.x, r2, c19
mad r2.x, r0.w, r0.y, c22.z
mad r0.w, r0, r2.x, c22
pow r2, c21.y, r0.w
rcp r0.y, r3.w
add r0.y, -r0, c13.x
mul r0.y, r0, c20.x
pow r3, c21.y, r0.y
mov r0.y, r2.x
mov r2.w, r3.x
mad r0.x, r0.y, c19, -r0
mad r0.x, r2.w, r0, r4.w
mul r2.xyz, -r0.x, r4
mov r5.z, r0
pow r4, c21.y, r2.z
pow r0, c21.y, r2.x
mul r1.w, r1, c18.x
mul r0.y, r1.w, r5.w
mul r3.xyz, r5, r0.y
mov r2.x, r0
pow r0, c21.y, r2.y
mov r2.y, r0
mov r0.xyz, c11
mov r2.z, r4
mul r0.w, r2, r1
mad r2.xyz, r2, r0.w, r3
mul r0.xyz, c14.x, r0
mul oD0.xyz, r2, r0
mul oD1.xyz, r2, c15.x
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