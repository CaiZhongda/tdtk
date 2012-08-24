xof 0303txt 0032

// DirectX 9.0 file
// Creator: Ultimate Unwrap3D Pro v3.22
// Website: http://www.unwrap3d.com
// Time: Fri Mar 12 16:37:27 2010

// Start of Templates

template VertexDuplicationIndices {
 <b8d65549-d7c9-4995-89cf-53a9a8b031e3>
 DWORD nIndices;
 DWORD nOriginalVertices;
 array DWORD indices[nIndices];
}

template FVFData {
 <b6e70a0e-8ef9-4e83-94ad-ecc8b0c04897>
 DWORD dwFVF;
 DWORD nDWords;
 array DWORD data[nDWords];
}

template Header {
 <3D82AB43-62DA-11cf-AB39-0020AF71E433>
 WORD major;
 WORD minor;
 DWORD flags;
}

template Vector {
 <3D82AB5E-62DA-11cf-AB39-0020AF71E433>
 FLOAT x;
 FLOAT y;
 FLOAT z;
}

template Coords2d {
 <F6F23F44-7686-11cf-8F52-0040333594A3>
 FLOAT u;
 FLOAT v;
}

template Matrix4x4 {
 <F6F23F45-7686-11cf-8F52-0040333594A3>
 array FLOAT matrix[16];
}

template ColorRGBA {
 <35FF44E0-6C7C-11cf-8F52-0040333594A3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
 FLOAT alpha;
}

template ColorRGB {
 <D3E16E81-7835-11cf-8F52-0040333594A3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
}

template IndexedColor {
 <1630B820-7842-11cf-8F52-0040333594A3>
 DWORD index;
 ColorRGBA indexColor;
}

template Material {
 <3D82AB4D-62DA-11cf-AB39-0020AF71E433>
 ColorRGBA faceColor;
 FLOAT power;
 ColorRGB specularColor;
 ColorRGB emissiveColor;
 [...]
}

template TextureFilename {
 <A42790E1-7810-11cf-8F52-0040333594A3>
 STRING filename;
}

template MeshFace {
 <3D82AB5F-62DA-11cf-AB39-0020AF71E433>
 DWORD nFaceVertexIndices;
 array DWORD faceVertexIndices[nFaceVertexIndices];
}

template MeshTextureCoords {
 <F6F23F40-7686-11cf-8F52-0040333594A3>
 DWORD nTextureCoords;
 array Coords2d textureCoords[nTextureCoords];
}

template MeshMaterialList {
 <F6F23F42-7686-11cf-8F52-0040333594A3>
 DWORD nMaterials;
 DWORD nFaceIndexes;
 array DWORD faceIndexes[nFaceIndexes];
 [Material]
}

template MeshNormals {
 <F6F23F43-7686-11cf-8F52-0040333594A3>
 DWORD nNormals;
 array Vector normals[nNormals];
 DWORD nFaceNormals;
 array MeshFace faceNormals[nFaceNormals];
}

template MeshVertexColors {
 <1630B821-7842-11cf-8F52-0040333594A3>
 DWORD nVertexColors;
 array IndexedColor vertexColors[nVertexColors];
}

template Mesh {
 <3D82AB44-62DA-11cf-AB39-0020AF71E433>
 DWORD nVertices;
 array Vector vertices[nVertices];
 DWORD nFaces;
 array MeshFace faces[nFaces];
 [...]
}

template FrameTransformMatrix {
 <F6F23F41-7686-11cf-8F52-0040333594A3>
 Matrix4x4 frameMatrix;
}

template Frame {
 <3D82AB46-62DA-11cf-AB39-0020AF71E433>
 [...]
}

template FloatKeys {
 <10DD46A9-775B-11cf-8F52-0040333594A3>
 DWORD nValues;
 array FLOAT values[nValues];
}

template TimedFloatKeys {
 <F406B180-7B3B-11cf-8F52-0040333594A3>
 DWORD time;
 FloatKeys tfkeys;
}

template AnimationKey {
 <10DD46A8-775B-11cf-8F52-0040333594A3>
 DWORD keyType;
 DWORD nKeys;
 array TimedFloatKeys keys[nKeys];
}

template AnimationOptions {
 <E2BF56C0-840F-11cf-8F52-0040333594A3>
 DWORD openclosed;
 DWORD positionquality;
}

template Animation {
 <3D82AB4F-62DA-11cf-AB39-0020AF71E433>
 [...]
}

template AnimationSet {
 <3D82AB50-62DA-11cf-AB39-0020AF71E433>
 [Animation]
}

template XSkinMeshHeader {
 <3CF169CE-FF7C-44ab-93C0-F78F62D172E2>
 WORD nMaxSkinWeightsPerVertex;
 WORD nMaxSkinWeightsPerFace;
 WORD nBones;
}

template SkinWeights {
 <6F0D123B-BAD2-4167-A0D0-80224F25FABB>
 STRING transformNodeName;
 DWORD nWeights;
 array DWORD vertexIndices[nWeights];
 array FLOAT weights[nWeights];
 Matrix4x4 matrixOffset;
}

template AnimTicksPerSecond {
 <9E415A43-7BA6-4a73-8743-B73D47E88476>
 DWORD AnimTicksPerSecond;
}

AnimTicksPerSecond {
 4800;
}

// Start of Frames

Frame rock_005_LOD1 {
   FrameTransformMatrix {
    1.000000, 0.000000, 0.000000, 0.000000,
    0.000000, 1.000000, 0.000000, 0.000000,
    0.000000, 0.000000, 1.000000, 0.000000,
    0.000000, 0.000000, 0.000000, 1.000000;;
   }

   Mesh rock_005_LOD1 {
    192;
    3.422689; 0.000000; 4.608419;,
    4.505376; 0.000000; 4.093803;,
    3.671602; 1.541799; 4.057212;,
    0.086742; 0.000000; 2.902668;,
    0.254408; 0.000000; 4.129023;,
    0.440873; 1.755621; 2.426705;,
    0.834966; 3.332165; 2.674143;,
    3.412971; 1.884608; -1.943635;,
    4.809536; 0.000000; -2.776260;,
    3.104085; 0.000000; -2.875891;,
    4.165281; 1.930903; -1.032319;,
    3.914606; 4.827389; -1.391253;,
    5.311622; 6.085311; -1.282300;,
    4.748242; 6.591494; 2.699423;,
    3.413782; 4.798454; 3.394934;,
    5.010642; 6.149117; 1.639994;,
    4.364429; 4.382118; 1.577312;,
    5.321992; 4.196311; -0.219624;,
    2.779696; 7.906800; 2.749196;,
    4.503894; 8.776919; 1.314318;,
    2.657599; 8.317539; 1.792845;,
    3.290367; 9.060663; 0.512643;,
    4.520995; 9.101785; 0.662534;,
    2.761655; 7.992751; -1.216815;,
    4.278242; 8.685104; -0.534181;,
    4.785442; 6.502364; -1.415886;,
    5.703640; 7.594446; -0.299411;,
    5.400465; 5.375689; 0.341779;,
    5.514268; 7.727317; 0.461554;,
    5.893756; 4.616239; 0.486560;,
    5.095333; 7.313253; 1.493854;,
    2.336310; 6.117121; 2.815587;,
    1.622950; 6.671655; 2.111408;,
    0.589578; 3.495890; 1.799877;,
    -2.841302; 6.498978; 2.405846;,
    -2.765988; 6.788138; 1.334562;,
    -3.888278; 6.353880; 1.675804;,
    -2.580050; 3.383693; -1.804428;,
    -3.112544; 3.122075; -0.957754;,
    -2.148129; 5.177452; -1.198640;,
    3.275687; 3.097266; -1.079785;,
    4.788919; 1.892998; -0.076724;,
    5.780180; 1.409408; 1.202009;,
    4.424887; 1.972240; 0.572935;,
    5.500789; 3.008032; 0.655212;,
    3.797934; 1.863251; 1.694897;,
    3.188522; 3.390686; 3.703762;,
    1.433100; 3.376395; 2.854744;,
    1.405516; 1.631889; 4.056851;,
    1.699975; 0.000000; 5.113670;,
    0.147235; 0.000000; -3.822173;,
    0.662071; 1.671598; -3.792412;,
    1.015855; 0.000000; -4.800442;,
    1.168682; 1.796629; -4.631453;,
    1.209867; 6.466265; -2.741846;,
    2.010155; 5.859905; -3.111561;,
    0.900482; 3.570769; -3.194940;,
    1.454222; 3.527638; -4.392496;,
    3.371833; 7.548131; -1.360066;,
    2.289937; 6.189743; -1.323863;,
    4.503894; 8.776919; 1.314318;,
    1.643702; 3.407736; 3.834473;,
    2.364872; 5.577563; 3.807100;,
    3.465983; 1.540545; 4.525966;,
    1.699975; 0.000000; 5.113670;,
    1.243954; 1.133117; -4.953860;,
    1.980446; 1.087443; -4.856220;,
    2.000901; 0.000000; -4.530849;,
    5.296438; 7.752348; -1.326160;,
    4.314003; 5.880875; -2.180250;,
    4.777390; 8.395602; -1.428619;,
    5.095333; 7.313253; 1.493854;,
    5.749122; 7.574262; 1.313876;,
    1.433100; 3.376395; 2.854744;,
    1.405516; 1.631889; 4.056851;,
    1.704448; 1.643128; 4.657997;,
    -0.831901; 1.521736; 3.594042;,
    -1.194038; 0.000000; 3.569569;,
    0.086742; 0.000000; 2.902668;,
    -0.563078; 1.575784; -3.891894;,
    1.522538; 7.251524; -0.304405;,
    0.369778; 6.910494; 0.633875;,
    0.640418; 6.381428; -1.138340;,
    -0.056810; 6.861893; -0.447773;,
    -0.494821; 3.407065; -3.608334;,
    -1.387163; 0.000000; -3.945492;,
    -2.057120; 0.000000; -3.677393;,
    -0.787497; 4.860679; -0.881827;,
    -0.413479; 6.203319; 1.461735;,
    -0.622333; 6.347794; 0.483355;,
    -1.160059; 5.036854; 1.511820;,
    1.713987; 6.688463; -2.131050;,
    2.453217; 6.046145; -2.446466;,
    3.412971; 1.884608; -1.943635;,
    3.104085; 0.000000; -2.875891;,
    3.621507; 1.433975; -3.274876;,
    3.252509; 0.000000; -3.945527;,
    3.872674; 5.067357; -2.095112;,
    3.914606; 4.827389; -1.391253;,
    0.541855; 6.945757; -1.959059;,
    -1.629934; 2.395504; -2.325381;,
    -1.448562; 2.732096; -1.362768;,
    -0.769373; 5.493865; -1.900957;,
    -0.787497; 4.860679; -0.881827;,
    -2.805358; 3.720149; 3.156035;,
    -1.834664; 2.157450; 1.779151;,
    -2.637923; 5.610169; 2.702355;,
    -1.825417; 5.150232; 1.600389;,
    -1.863050; 0.000000; 2.622398;,
    -2.451736; 1.424011; 3.827287;,
    -2.061018; 0.000000; 3.846488;,
    -2.390936; 5.779131; -0.502818;,
    -4.580757; 4.186425; 2.995540;,
    -3.942441; 4.116347; 3.505712;,
    -5.425464; 1.339177; -1.859342;,
    -4.571817; 0.000000; -2.271452;,
    -5.870874; 0.000000; -2.135713;,
    -3.671960; 2.667854; -1.059071;,
    -3.466726; 1.235956; -0.979011;,
    -3.669951; 0.000000; -1.312597;,
    -4.278535; 4.760111; 0.924230;,
    -3.408013; 6.421340; 0.219601;,
    -3.020709; 5.611234; -0.271075;,
    -3.298098; 2.114822; -0.625042;,
    -1.345228; 5.577400; 0.769344;,
    -2.765050; 5.472408; -0.582547;,
    -2.725846; 6.461085; 0.334642;,
    -5.678174; 1.461757; 0.968318;,
    -5.940787; 1.446434; 0.492106;,
    -5.825053; 0.000000; 0.498841;,
    -5.646393; 2.587505; -1.180503;,
    -4.247700; 3.891621; -0.948822;,
    -4.035306; 2.586163; -1.832284;,
    -5.126725; 2.788201; 2.965172;,
    -4.070409; 3.075563; 3.334137;,
    -4.891893; 0.000000; 1.868609;,
    -5.459994; 3.487679; 0.209904;,
    -4.655243; 3.020403; 1.638746;,
    -5.043028; 4.243524; 0.436561;,
    -3.298098; 2.114822; -0.625042;,
    -3.466726; 1.235956; -0.979011;,
    -3.614468; 0.000000; -2.470559;,
    -3.669951; 0.000000; -1.312597;,
    -1.878412; 1.935994; -1.182202;,
    -1.834664; 2.157450; 1.779151;,
    -0.766281; 3.580019; 2.172080;,
    -1.183279; 2.144966; 3.071490;,
    -1.863050; 0.000000; 2.622398;,
    0.440873; 1.755621; 2.426705;,
    0.142962; 1.718148; 2.530127;,
    3.140610; 2.942957; -3.480039;,
    3.840827; 4.741530; -2.743337;,
    2.453217; 6.046145; -2.446466;,
    -0.759553; 3.167673; 3.234537;,
    1.713987; 6.688463; -2.131050;,
    2.453217; 6.046145; -2.446466;,
    2.023193; 6.951686; -2.644939;,
    3.797934; 1.863251; 1.694897;,
    5.061011; 3.082591; 1.757892;,
    4.364429; 4.382118; 1.577312;,
    5.010642; 6.149117; 1.639994;,
    2.289937; 6.189743; -1.323863;,
    3.371833; 7.548131; -1.360066;,
    3.141663; 7.282552; -2.100164;,
    4.785442; 6.502364; -1.415886;,
    1.898885; 2.298521; -4.472647;,
    3.275687; 3.097266; -1.079785;,
    2.297445; 3.079150; -3.689984;,
    -3.503173; 1.454142; 4.171073;,
    -4.933349; 0.000000; 3.171823;,
    -3.960211; 0.000000; 4.487255;,
    -5.215311; 2.339694; 1.787000;,
    -2.700617; 0.000000; -2.953316;,
    -1.878412; 1.935994; -1.182202;,
    -1.898117; 0.000000; -2.674303;,
    -1.898117; 0.000000; -2.674303;,
    -0.134794; 2.074211; -3.546396;,
    0.810218; 2.186192; -3.432367;,
    5.590448; 0.000000; -1.508157;,
    5.120800; 0.000000; 0.273959;,
    6.577708; 0.000000; 1.364423;,
    5.918904; 0.000000; 2.838349;,
    5.507479; 1.290907; 2.150543;,
    4.556553; 0.000000; 2.997207;,
    4.556553; 0.000000; 2.997207;,
    5.704764; 2.560213; 1.754020;,
    -6.150759; 0.000000; -1.241596;,
    -6.194576; 0.902210; -1.406327;,
    -6.384699; 1.400467; -0.958897;,
    -6.579073; 2.199637; 0.167924;,
    -6.466110; 0.000000; 0.131758;,
    2.076717; 8.220479; 0.142328;;
    291;
    3;0, 1, 2;,
    3;3, 4, 5;,
    3;4, 6, 5;,
    3;7, 8, 9;,
    3;10, 11, 12;,
    3;13, 14, 15;,
    3;14, 16, 15;,
    3;12, 17, 10;,
    3;18, 19, 20;,
    3;21, 20, 22;,
    3;20, 19, 22;,
    3;23, 21, 24;,
    3;12, 25, 26;,
    3;27, 12, 26;,
    3;28, 29, 27;,
    3;13, 15, 30;,
    3;31, 32, 6;,
    3;6, 32, 33;,
    3;34, 35, 36;,
    3;37, 38, 39;,
    3;40, 11, 10;,
    3;41, 10, 17;,
    3;42, 43, 44;,
    3;27, 29, 43;,
    3;43, 29, 44;,
    3;45, 16, 46;,
    3;46, 16, 14;,
    3;6, 47, 31;,
    3;6, 4, 48;,
    3;49, 48, 4;,
    3;50, 51, 52;,
    3;51, 53, 52;,
    3;54, 55, 56;,
    3;55, 57, 56;,
    3;58, 59, 23;,
    3;23, 24, 58;,
    3;13, 30, 18;,
    3;18, 30, 60;,
    3;13, 18, 14;,
    3;31, 14, 18;,
    3;61, 46, 62;,
    3;46, 14, 62;,
    3;0, 63, 64;,
    3;65, 66, 52;,
    3;52, 66, 67;,
    3;68, 69, 70;,
    3;19, 28, 22;,
    3;71, 72, 19;,
    3;31, 62, 14;,
    3;73, 61, 31;,
    3;31, 61, 62;,
    3;2, 63, 0;,
    3;74, 64, 75;,
    3;76, 77, 78;,
    3;51, 50, 79;,
    3;80, 81, 32;,
    3;59, 82, 80;,
    3;80, 82, 83;,
    3;84, 54, 56;,
    3;50, 85, 79;,
    3;79, 85, 86;,
    3;87, 39, 83;,
    3;88, 89, 90;,
    3;91, 59, 92;,
    3;93, 94, 95;,
    3;94, 96, 95;,
    3;97, 69, 98;,
    3;91, 99, 59;,
    3;82, 59, 99;,
    3;100, 101, 102;,
    3;101, 103, 102;,
    3;99, 102, 82;,
    3;103, 82, 102;,
    3;104, 105, 106;,
    3;105, 107, 106;,
    3;108, 109, 110;,
    3;111, 39, 38;,
    3;112, 113, 36;,
    3;36, 113, 34;,
    3;113, 106, 34;,
    3;114, 115, 116;,
    3;35, 34, 107;,
    3;106, 107, 34;,
    3;117, 118, 119;,
    3;120, 121, 122;,
    3;123, 117, 122;,
    3;124, 39, 111;,
    3;125, 126, 107;,
    3;35, 107, 126;,
    3;121, 35, 126;,
    3;121, 36, 35;,
    3;120, 36, 121;,
    3;127, 128, 129;,
    3;130, 131, 132;,
    3;133, 134, 112;,
    3;134, 113, 112;,
    3;134, 106, 113;,
    3;117, 119, 115;,
    3;122, 131, 120;,
    3;122, 117, 131;,
    3;129, 135, 127;,
    3;136, 137, 138;,
    3;125, 122, 126;,
    3;122, 121, 126;,
    3;122, 125, 139;,
    3;38, 139, 125;,
    3;140, 141, 142;,
    3;82, 103, 83;,
    3;143, 103, 101;,
    3;144, 145, 90;,
    3;111, 38, 125;,
    3;125, 107, 111;,
    3;124, 111, 107;,
    3;90, 124, 107;,
    3;107, 144, 90;,
    3;146, 147, 77;,
    3;33, 88, 145;,
    3;145, 88, 90;,
    3;78, 148, 149;,
    3;32, 88, 33;,
    3;32, 81, 88;,
    3;81, 89, 88;,
    3;150, 151, 93;,
    3;151, 55, 97;,
    3;152, 97, 55;,
    3;91, 54, 99;,
    3;84, 102, 54;,
    3;102, 99, 54;,
    3;100, 102, 84;,
    3;145, 153, 33;,
    3;145, 144, 153;,
    3;144, 146, 153;,
    3;154, 155, 156;,
    3;55, 156, 152;,
    3;54, 156, 55;,
    3;54, 91, 156;,
    3;157, 158, 159;,
    3;159, 158, 160;,
    3;160, 158, 72;,
    3;71, 160, 72;,
    3;19, 72, 28;,
    3;72, 29, 28;,
    3;158, 29, 72;,
    3;29, 158, 44;,
    3;161, 162, 163;,
    3;26, 164, 68;,
    3;164, 69, 68;,
    3;24, 70, 162;,
    3;162, 70, 163;,
    3;26, 68, 70;,
    3;57, 165, 53;,
    3;97, 166, 151;,
    3;151, 166, 93;,
    3;98, 166, 97;,
    3;55, 167, 57;,
    3;52, 53, 65;,
    3;167, 165, 57;,
    3;56, 57, 53;,
    3;46, 2, 45;,
    3;1, 45, 2;,
    3;63, 2, 46;,
    3;75, 63, 61;,
    3;63, 46, 61;,
    3;73, 74, 61;,
    3;74, 75, 61;,
    3;48, 47, 6;,
    3;5, 6, 33;,
    3;149, 148, 33;,
    3;33, 153, 149;,
    3;78, 149, 153;,
    3;76, 78, 153;,
    3;153, 146, 76;,
    3;77, 76, 146;,
    3;146, 144, 147;,
    3;104, 109, 105;,
    3;109, 108, 105;,
    3;168, 109, 104;,
    3;169, 170, 133;,
    3;136, 127, 171;,
    3;127, 135, 171;,
    3;128, 127, 136;,
    3;118, 117, 123;,
    3;141, 140, 37;,
    3;172, 141, 37;,
    3;37, 173, 172;,
    3;173, 174, 172;,
    3;101, 175, 143;,
    3;86, 175, 100;,
    3;175, 101, 100;,
    3;100, 176, 86;,
    3;176, 79, 86;,
    3;51, 79, 177;,
    3;177, 79, 176;,
    3;53, 51, 177;,
    3;53, 165, 65;,
    3;66, 65, 165;,
    3;167, 67, 165;,
    3;67, 66, 165;,
    3;67, 167, 96;,
    3;96, 167, 150;,
    3;93, 95, 150;,
    3;95, 96, 150;,
    3;40, 10, 7;,
    3;8, 7, 10;,
    3;178, 8, 41;,
    3;8, 10, 41;,
    3;179, 43, 180;,
    3;180, 43, 42;,
    3;180, 42, 181;,
    3;181, 42, 182;,
    3;183, 181, 182;,
    3;1, 184, 45;,
    3;178, 41, 179;,
    3;43, 179, 41;,
    3;27, 43, 17;,
    3;43, 41, 17;,
    3;26, 28, 27;,
    3;22, 28, 26;,
    3;21, 22, 24;,
    3;81, 80, 83;,
    3;89, 81, 83;,
    3;39, 89, 83;,
    3;167, 151, 150;,
    3;42, 185, 182;,
    3;157, 183, 182;,
    3;182, 185, 157;,
    3;158, 157, 185;,
    3;44, 185, 42;,
    3;44, 158, 185;,
    3;63, 75, 64;,
    3;109, 168, 110;,
    3;110, 168, 170;,
    3;186, 187, 116;,
    3;136, 171, 137;,
    3;104, 106, 134;,
    3;104, 134, 168;,
    3;168, 134, 170;,
    3;133, 170, 134;,
    3;120, 112, 36;,
    3;112, 137, 133;,
    3;137, 171, 133;,
    3;169, 133, 135;,
    3;135, 133, 171;,
    3;117, 115, 132;,
    3;130, 132, 114;,
    3;132, 115, 114;,
    3;188, 130, 114;,
    3;131, 130, 136;,
    3;189, 136, 130;,
    3;128, 136, 189;,
    3;129, 128, 190;,
    3;190, 189, 188;,
    3;189, 130, 188;,
    3;128, 189, 190;,
    3;138, 120, 131;,
    3;151, 167, 55;,
    3;137, 112, 120;,
    3;138, 137, 120;,
    3;124, 89, 39;,
    3;90, 89, 124;,
    3;39, 173, 37;,
    3;23, 191, 21;,
    3;191, 20, 21;,
    3;59, 80, 23;,
    3;80, 191, 23;,
    3;32, 20, 80;,
    3;20, 191, 80;,
    3;20, 32, 18;,
    3;31, 18, 32;,
    3;70, 69, 163;,
    3;26, 70, 24;,
    3;22, 26, 24;,
    3;98, 69, 164;,
    3;11, 25, 12;,
    3;27, 17, 12;,
    3;163, 69, 152;,
    3;69, 97, 152;,
    3;161, 163, 152;,
    3;188, 187, 186;,
    3;188, 114, 187;,
    3;114, 116, 187;,
    3;176, 100, 84;,
    3;140, 38, 37;,
    3;38, 140, 139;,
    3;56, 177, 84;,
    3;177, 176, 84;,
    3;53, 177, 56;,
    3;87, 173, 39;,
    3;190, 188, 186;,
    3;136, 138, 131;,
    3;131, 117, 132;;

   MeshTextureCoords {
    192;
    0.697022; 0.956672;,
    0.742998; 0.931441;,
    0.688009; 0.872535;,
    0.455366; 0.865217;,
    0.500498; 0.874921;,
    0.456203; 0.794711;,
    0.481730; 0.741982;,
    0.915472; 0.374604;,
    0.984008; 0.373623;,
    0.948639; 0.321472;,
    0.897219; 0.430757;,
    0.807998; 0.412209;,
    0.769825; 0.438245;,
    0.656543; 0.635032;,
    0.627964; 0.711974;,
    0.687982; 0.635321;,
    0.699199; 0.692005;,
    0.823172; 0.484576;,
    0.588133; 0.582091;,
    0.643784; 0.538419;,
    0.589253; 0.552919;,
    0.609883; 0.502893;,
    0.643261; 0.505816;,
    0.583959; 0.446810;,
    0.636070; 0.457990;,
    0.760643; 0.412169;,
    0.709657; 0.456234;,
    0.783019; 0.502108;,
    0.701788; 0.497257;,
    0.800708; 0.531420;,
    0.681188; 0.590438;,
    0.568020; 0.647725;,
    0.534398; 0.594611;,
    0.448214; 0.707930;,
    0.288257; 0.562076;,
    0.295076; 0.536940;,
    0.270649; 0.543592;,
    0.294555; 0.337764;,
    0.267210; 0.365550;,
    0.344105; 0.416005;,
    0.861771; 0.396326;,
    0.908888; 0.483313;,
    0.929230; 0.577872;,
    0.906092; 0.514665;,
    0.860034; 0.547265;,
    0.748049; 0.786928;,
    0.643252; 0.785610;,
    0.501397; 0.737893;,
    0.523920; 0.806382;,
    0.530756; 0.869609;,
    0.418646; 0.054179;,
    0.462118; 0.132687;,
    0.477412; 0.031160;,
    0.502138; 0.117602;,
    0.537230; 0.340616;,
    0.565824; 0.302126;,
    0.495349; 0.215188;,
    0.532785; 0.185982;,
    0.593827; 0.425617;,
    0.555458; 0.407325;,
    0.640427; 0.557177;,
    0.570256; 0.804848;,
    0.586756; 0.699347;,
    0.670678; 0.886156;,
    0.621092; 0.992632;,
    0.500933; 0.081560;,
    0.526606; 0.072698;,
    0.530655; 0.021948;,
    0.681106; 0.411793;,
    0.670594; 0.321889;,
    0.658801; 0.419382;,
    0.702697; 0.566471;,
    0.707091; 0.536614;,
    0.523573; 0.795357;,
    0.565519; 0.907286;,
    0.596746; 0.907612;,
    0.388835; 0.799560;,
    0.376667; 0.862718;,
    0.433211; 0.853321;,
    0.408694; 0.141379;,
    0.535382; 0.471949;,
    0.487659; 0.515047;,
    0.495784; 0.410221;,
    0.484191; 0.452034;,
    0.442080; 0.232758;,
    0.349452; 0.075279;,
    0.322065; 0.099054;,
    0.407862; 0.403638;,
    0.448231; 0.564317;,
    0.436234; 0.512382;,
    0.386645; 0.598912;,
    0.545659; 0.378195;,
    0.563646; 0.379692;,
    0.680746; 0.103918;,
    0.642248; 0.000000;,
    0.626809; 0.078531;,
    0.592258; 0.011212;,
    0.663095; 0.275832;,
    0.698561; 0.274909;,
    0.510794; 0.374522;,
    0.366686; 0.239804;,
    0.348919; 0.285998;,
    0.452516; 0.344132;,
    0.413951; 0.379245;,
    0.258370; 0.666673;,
    0.320577; 0.765732;,
    0.290893; 0.587691;,
    0.347749; 0.581600;,
    0.273218; 0.839517;,
    0.220521; 0.771996;,
    0.204447; 0.845824;,
    0.331192; 0.460487;,
    0.212404; 0.601977;,
    0.227445; 0.621527;,
    0.073180; 0.388191;,
    0.052873; 0.311014;,
    0.017023; 0.371244;,
    0.176884; 0.348965;,
    0.132905; 0.281269;,
    0.087425; 0.255618;,
    0.221109; 0.518155;,
    0.283368; 0.507026;,
    0.293973; 0.467780;,
    0.198764; 0.324464;,
    0.383703; 0.532423;,
    0.311566; 0.455507;,
    0.300926; 0.511209;,
    0.079285; 0.559702;,
    0.071716; 0.533788;,
    0.007454; 0.556250;,
    0.112034; 0.434585;,
    0.188526; 0.426750;,
    0.145543; 0.368155;,
    0.165099; 0.633444;,
    0.205829; 0.658613;,
    0.040920; 0.647390;,
    0.146363; 0.498251;,
    0.163571; 0.571189;,
    0.184054; 0.501313;,
    0.236231; 0.359806;,
    0.212493; 0.327141;,
    0.196377; 0.261544;,
    0.182576; 0.298548;,
    0.322263; 0.280771;,
    0.321586; 0.750955;,
    0.389011; 0.697487;,
    0.369489; 0.773597;,
    0.326738; 0.850986;,
    0.445780; 0.779580;,
    0.435306; 0.782769;,
    0.609485; 0.156399;,
    0.641047; 0.248878;,
    0.598752; 0.319316;,
    0.390912; 0.740963;,
    0.590098; 0.382814;,
    0.609847; 0.340601;,
    0.572071; 0.358478;,
    0.864773; 0.684757;,
    0.843154; 0.605821;,
    0.790000; 0.618284;,
    0.744466; 0.576936;,
    0.573103; 0.349417;,
    0.616988; 0.390101;,
    0.621991; 0.363901;,
    0.697313; 0.356070;,
    0.538746; 0.127582;,
    0.722401; 0.170611;,
    0.573372; 0.166033;,
    0.179704; 0.744072;,
    0.074163; 0.712356;,
    0.121958; 0.785187;,
    0.129501; 0.588704;,
    0.216065; 0.230075;,
    0.315594; 0.271404;,
    0.242780; 0.213325;,
    0.287337; 0.150080;,
    0.427856; 0.170746;,
    0.470231; 0.161443;,
    0.990675; 0.434263;,
    0.982365; 0.514906;,
    0.995287; 0.597302;,
    0.981041; 0.669119;,
    0.924803; 0.639015;,
    0.947240; 0.716414;,
    0.766302; 0.877782;,
    0.880446; 0.598381;,
    0.000909; 0.427074;,
    0.042396; 0.423802;,
    0.060826; 0.449679;,
    0.089249; 0.495619;,
    0.007738; 0.507214;,
    0.571396; 0.492443;;
   }

   MeshMaterialList {
    1;
    291;
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0;

    Material lambert13SG {
     1.000000; 1.000000; 1.000000; 1.000000;;
     128.000000;
     0.050000; 0.050000; 0.050000;;
     0.000000; 0.000000; 0.000000;;

     TextureFilename {
      "rock_005_c.tga";
     }
    }

   }
  }
}