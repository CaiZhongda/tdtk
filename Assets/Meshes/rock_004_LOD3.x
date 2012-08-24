xof 0303txt 0032

// DirectX 9.0 file
// Creator: Ultimate Unwrap3D Pro v3.22
// Website: http://www.unwrap3d.com
// Time: Fri Mar 12 16:36:03 2010

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

Frame rock_004_LOD3 {
   FrameTransformMatrix {
    1.000000, 0.000000, 0.000000, 0.000000,
    0.000000, 1.000000, 0.000000, 0.000000,
    0.000000, 0.000000, 1.000000, 0.000000,
    0.000000, 0.000000, 0.000000, 1.000000;;
   }

   Mesh rock_004_LOD3 {
    67;
    2.702492; 4.907796; -2.312471;,
    4.916130; 4.278453; -2.679673;,
    2.806604; 3.422909; -2.956794;,
    -0.367086; 0.000000; -3.827615;,
    0.456539; 2.929559; -3.512792;,
    1.747455; 0.000000; -3.795209;,
    6.265324; 6.202698; 2.177856;,
    5.115801; 4.578790; 3.058849;,
    9.764750; 7.696551; 1.249818;,
    8.974304; 8.521649; 0.771804;,
    2.888303; 7.243459; 1.127126;,
    6.010868; 7.104063; 2.110646;,
    6.733440; 4.496346; 2.101158;,
    7.864853; 5.338656; 0.033026;,
    9.764750; 7.696551; 1.249818;,
    4.645355; 0.312087; 0.304221;,
    5.599039; 0.000000; -1.659528;,
    5.584155; 2.361454; -1.544405;,
    -2.231400; 0.000000; 4.799671;,
    -0.799277; 0.000000; 4.523886;,
    0.236795; 2.318805; 3.594535;,
    8.963415; 8.223250; -0.868791;,
    9.692261; 7.678814; -0.864981;,
    6.776563; 6.231162; -1.988701;,
    9.866330; 7.862214; 0.584839;,
    9.692261; 7.678814; -0.864981;,
    8.963415; 8.223250; -0.868791;,
    1.767081; 4.097163; 3.693436;,
    3.139807; 4.788755; 3.059627;,
    3.275592; 5.730975; 3.097877;,
    7.477352; 6.090632; 1.114478;,
    3.479909; 2.943453; -2.189015;,
    4.723814; 1.849995; -2.519339;,
    2.198233; 1.825075; 2.536356;,
    1.036325; 0.000000; 3.322663;,
    4.435477; 3.245261; 2.613264;,
    7.154588; 5.124682; -1.688944;,
    10.407039; 7.430336; 0.221690;,
    4.435477; 3.245261; 2.613264;,
    7.477352; 6.090632; 1.114478;,
    1.194726; 2.080292; 3.542201;,
    2.198233; 1.825075; 2.536356;,
    1.036325; 0.000000; 3.322663;,
    4.754885; 0.000000; 3.268413;,
    5.475165; 2.155577; 2.448462;,
    2.572052; 0.000000; -4.132660;,
    3.510488; 2.216589; -3.248532;,
    -1.626047; 1.838922; -3.785700;,
    -0.181239; 5.272309; -1.251865;,
    -0.078633; 5.161983; 1.931451;,
    -3.275813; 2.868428; 0.905558;,
    -5.166955; 0.000000; 1.467781;,
    -3.269081; 2.456162; 2.158035;,
    6.460914; 3.176028; 0.348131;,
    10.407039; 7.430336; 0.221690;,
    2.294472; 5.855348; -1.644410;,
    0.194242; 4.966297; -2.398948;,
    -2.555288; 3.338722; -3.681635;,
    -1.528397; 3.639777; 3.175776;,
    5.922216; 0.000000; 1.915612;,
    -5.533262; 0.000000; 2.811630;,
    -3.923258; 0.000000; 4.599424;,
    -2.919442; 4.009762; -0.274110;,
    -5.938643; 0.000000; -1.899284;,
    -2.059394; 0.000000; -5.089070;,
    -3.685162; 2.529626; 3.091037;,
    -4.552048; 0.000000; 4.247269;;
    100;
    3;0, 1, 2;,
    3;3, 4, 5;,
    3;6, 7, 8;,
    3;9, 10, 11;,
    3;12, 13, 14;,
    3;2, 4, 0;,
    3;15, 16, 17;,
    3;18, 19, 20;,
    3;21, 22, 23;,
    3;24, 25, 26;,
    3;9, 8, 24;,
    3;9, 6, 8;,
    3;27, 28, 29;,
    3;20, 28, 27;,
    3;14, 30, 12;,
    3;31, 1, 32;,
    3;33, 34, 35;,
    3;35, 12, 30;,
    3;22, 36, 23;,
    3;24, 37, 25;,
    3;7, 38, 39;,
    3;7, 39, 8;,
    3;40, 41, 38;,
    3;40, 38, 7;,
    3;42, 41, 40;,
    3;1, 23, 36;,
    3;2, 1, 31;,
    3;35, 34, 43;,
    3;35, 43, 44;,
    3;1, 17, 32;,
    3;45, 46, 32;,
    3;9, 11, 6;,
    3;26, 9, 24;,
    3;3, 47, 4;,
    3;37, 24, 8;,
    3;10, 48, 49;,
    3;50, 51, 52;,
    3;16, 45, 32;,
    3;53, 17, 36;,
    3;54, 13, 36;,
    3;54, 36, 22;,
    3;55, 10, 9;,
    3;55, 9, 21;,
    3;56, 48, 55;,
    3;57, 48, 56;,
    3;49, 48, 50;,
    3;49, 50, 52;,
    3;20, 27, 58;,
    3;10, 29, 11;,
    3;1, 0, 23;,
    3;17, 1, 36;,
    3;12, 44, 53;,
    3;12, 35, 44;,
    3;6, 28, 7;,
    3;29, 28, 6;,
    3;11, 29, 6;,
    3;42, 40, 19;,
    3;19, 40, 20;,
    3;57, 56, 47;,
    3;5, 4, 2;,
    3;15, 44, 59;,
    3;52, 51, 60;,
    3;20, 58, 61;,
    3;62, 63, 51;,
    3;62, 51, 50;,
    3;55, 48, 10;,
    3;50, 48, 62;,
    3;58, 27, 29;,
    3;55, 21, 23;,
    3;55, 23, 0;,
    3;56, 55, 0;,
    3;56, 0, 4;,
    3;47, 56, 4;,
    3;17, 16, 32;,
    3;46, 45, 5;,
    3;31, 32, 46;,
    3;2, 46, 5;,
    3;46, 2, 31;,
    3;47, 3, 64;,
    3;57, 62, 48;,
    3;63, 62, 57;,
    3;65, 61, 58;,
    3;66, 61, 65;,
    3;58, 52, 65;,
    3;52, 60, 65;,
    3;65, 60, 66;,
    3;18, 20, 61;,
    3;58, 49, 52;,
    3;29, 10, 49;,
    3;29, 49, 58;,
    3;59, 44, 43;,
    3;28, 20, 40;,
    3;28, 40, 7;,
    3;57, 64, 63;,
    3;57, 47, 64;,
    3;13, 53, 36;,
    3;12, 53, 13;,
    3;15, 17, 53;,
    3;14, 13, 54;,
    3;44, 15, 53;;

   MeshTextureCoords {
    67;
    0.566949; 0.358400;,
    0.661679; 0.320268;,
    0.582398; 0.261591;,
    0.440008; 0.082462;,
    0.476117; 0.230619;,
    0.565620; 0.096256;,
    0.628450; 0.711087;,
    0.567639; 0.767705;,
    0.770103; 0.723715;,
    0.756366; 0.640524;,
    0.536780; 0.575562;,
    0.625178; 0.663243;,
    0.874861; 0.298195;,
    0.813812; 0.377568;,
    0.887017; 0.487026;,
    0.779636; 0.162798;,
    0.727013; 0.157019;,
    0.727919; 0.241640;,
    0.236779; 0.854406;,
    0.302417; 0.892557;,
    0.357215; 0.784102;,
    0.749045; 0.529323;,
    0.791119; 0.515957;,
    0.698961; 0.431217;,
    0.796550; 0.688548;,
    0.830549; 0.634064;,
    0.798654; 0.605804;,
    0.441298; 0.716615;,
    0.502540; 0.736480;,
    0.513158; 0.678475;,
    0.890862; 0.371826;,
    0.624949; 0.260733;,
    0.680594; 0.211123;,
    0.971976; 0.148835;,
    0.983552; 0.069275;,
    0.914296; 0.219831;,
    0.733449; 0.370118;,
    0.830864; 0.690565;,
    0.548615; 0.832712;,
    0.689930; 0.783019;,
    0.408097; 0.832058;,
    0.458629; 0.883344;,
    0.377200; 0.934866;,
    0.873123; 0.106902;,
    0.863168; 0.187656;,
    0.618384; 0.113855;,
    0.623106; 0.212532;,
    0.364761; 0.178989;,
    0.420983; 0.438498;,
    0.403892; 0.593094;,
    0.224860; 0.506865;,
    0.031292; 0.519037;,
    0.203889; 0.600626;,
    0.801978; 0.270314;,
    0.849199; 0.511717;,
    0.537940; 0.430323;,
    0.444189; 0.361168;,
    0.318886; 0.270821;,
    0.313713; 0.665730;,
    0.821833; 0.135131;,
    0.013628; 0.672978;,
    0.164008; 0.812809;,
    0.281723; 0.440400;,
    0.082297; 0.255409;,
    0.318485; 0.074490;,
    0.181464; 0.674100;,
    0.089336; 0.814819;;
   }

   MeshMaterialList {
    1;
    100;
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
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

    Material lambert12SG {
     1.000000; 1.000000; 1.000000; 1.000000;;
     128.000000;
     0.050000; 0.050000; 0.050000;;
     0.000000; 0.000000; 0.000000;;

     TextureFilename {
      "rock_004_c.tga";
     }
    }

   }
  }
}