xof 0303txt 0032

// DirectX 9.0 file
// Creator: Ultimate Unwrap3D Pro v3.19
// Website: http://www.unwrap3d.com
// Time: Sun Nov 22 10:01:38 2009

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

Frame Grenade_Launcher_Base_lod2 {
   FrameTransformMatrix {
    1.000000, 0.000000, 0.000000, 0.000000,
    0.000000, 1.000000, 0.000000, 0.000000,
    0.000000, 0.000000, 1.000000, 0.000000,
    0.000000, 0.000000, 0.000000, 1.000000;;
   }

   Mesh Grenade_Launcher_Base_lod2 {
    60;
    -0.393444; 0.773872; -0.411835;,
    -0.393444; 0.773872; 0.415781;,
    0.399220; 0.773872; -0.411834;,
    0.399220; 0.773872; 0.415782;,
    0.399220; 0.773872; 0.415782;,
    -0.589401; -0.004981; 0.620378;,
    0.595177; -0.004982; 0.620379;,
    -0.393444; 0.773872; 0.415781;,
    0.399220; 0.773872; 0.415782;,
    0.595177; -0.004982; 0.620379;,
    0.595177; -0.004982; -0.616432;,
    0.399220; 0.773872; -0.411834;,
    -0.393444; 0.773872; -0.411835;,
    0.399220; 0.773872; -0.411834;,
    -0.589401; -0.004982; -0.616432;,
    0.595177; -0.004982; -0.616432;,
    -0.589401; -0.004981; 0.620378;,
    -0.393444; 0.773872; -0.411835;,
    -0.589401; -0.004982; -0.616432;,
    -0.393444; 0.773872; 0.415781;,
    -0.436073; 0.339869; 0.167482;,
    -1.257002; -0.013872; -0.113792;,
    -1.257002; -0.013872; 0.167482;,
    -0.436073; 0.339869; -0.113792;,
    -0.436073; 0.339869; -0.113792;,
    -0.436073; -0.013872; -0.113792;,
    -1.257002; -0.013872; -0.113792;,
    -0.436073; -0.013872; 0.167482;,
    -0.436073; 0.339869; 0.167482;,
    -1.257002; -0.013872; 0.167482;,
    -0.088900; -0.013872; -1.316708;,
    0.192374; 0.339869; -0.495779;,
    0.192374; -0.013872; -1.316708;,
    -0.088900; 0.339869; -0.495779;,
    -0.088900; -0.013872; -0.495779;,
    -0.088900; 0.339869; -0.495779;,
    -0.088900; -0.013872; -1.316708;,
    0.192374; 0.339869; -0.495779;,
    0.192374; -0.013872; -0.495778;,
    0.192374; -0.013872; -1.316708;,
    0.192374; 0.339869; 0.495778;,
    -0.088900; 0.339869; 0.495778;,
    0.192374; -0.013872; 1.316708;,
    -0.088900; -0.013872; 1.316708;,
    -0.088900; -0.013872; 1.316708;,
    -0.088900; 0.339869; 0.495778;,
    -0.088900; -0.013872; 0.495779;,
    0.192374; 0.339869; 0.495778;,
    0.192374; -0.013872; 1.316708;,
    0.192374; -0.013872; 0.495779;,
    1.257002; -0.005101; -0.113792;,
    0.436073; 0.348640; -0.113792;,
    1.257002; -0.005101; 0.167482;,
    0.436073; 0.348640; 0.167482;,
    0.436073; 0.348640; 0.167482;,
    0.436073; -0.005101; 0.167482;,
    1.257002; -0.005101; 0.167482;,
    0.436073; -0.005101; -0.113792;,
    0.436073; 0.348640; -0.113792;,
    1.257002; -0.005101; -0.113792;;
    26;
    3;0, 1, 2;,
    3;1, 3, 2;,
    3;4, 5, 6;,
    3;4, 7, 5;,
    3;8, 9, 10;,
    3;11, 8, 10;,
    3;12, 13, 14;,
    3;14, 13, 15;,
    3;16, 17, 18;,
    3;19, 17, 16;,
    3;20, 21, 22;,
    3;20, 23, 21;,
    3;24, 25, 26;,
    3;27, 28, 29;,
    3;30, 31, 32;,
    3;33, 31, 30;,
    3;34, 35, 36;,
    3;37, 38, 39;,
    3;40, 41, 42;,
    3;41, 43, 42;,
    3;44, 45, 46;,
    3;47, 48, 49;,
    3;50, 51, 52;,
    3;51, 53, 52;,
    3;54, 55, 56;,
    3;57, 58, 59;;

   MeshNormals {
    60;
    -0.697515; 0.626490; -0.347826;,
    -0.340404; 0.876852; 0.339494;,
    0.277006; 0.786115; -0.552531;,
    0.572237; 0.588928; 0.570709;,
    0.572237; 0.588928; 0.570709;,
    -0.665421; 0.341750; 0.663643;,
    0.665421; 0.341750; 0.663643;,
    -0.340404; 0.876852; 0.339494;,
    0.572237; 0.588928; 0.570709;,
    0.665421; 0.341750; 0.663643;,
    0.846655; 0.323922; -0.422196;,
    0.277006; 0.786115; -0.552531;,
    -0.697515; 0.626490; -0.347826;,
    0.277006; 0.786115; -0.552531;,
    -0.423327; 0.328321; -0.844393;,
    0.846655; 0.323922; -0.422196;,
    -0.665421; 0.341750; 0.663643;,
    -0.697515; 0.626490; -0.347826;,
    -0.423327; 0.328321; -0.844393;,
    -0.340404; 0.876852; 0.339494;,
    -0.353950; 0.821413; 0.447214;,
    -0.353950; 0.821413; -0.447214;,
    -0.279822; 0.649384; 0.707107;,
    -0.279822; 0.649384; -0.707107;,
    -0.279822; 0.649384; -0.707107;,
    -0.000000; -0.000000; -1.000000;,
    -0.353950; 0.821413; -0.447214;,
    -0.000000; 0.000000; 1.000000;,
    -0.353950; 0.821413; 0.447214;,
    -0.279822; 0.649384; 0.707107;,
    -0.447213; 0.821413; -0.353950;,
    0.447214; 0.821413; -0.353949;,
    0.707107; 0.649384; -0.279822;,
    -0.707107; 0.649384; -0.279822;,
    -1.000000; 0.000000; -0.000000;,
    -0.707107; 0.649384; -0.279822;,
    -0.447213; 0.821413; -0.353950;,
    0.447214; 0.821413; -0.353949;,
    1.000000; 0.000000; 0.000000;,
    0.707107; 0.649384; -0.279822;,
    0.707107; 0.649384; 0.279822;,
    -0.447213; 0.821413; 0.353949;,
    0.447214; 0.821413; 0.353949;,
    -0.707107; 0.649384; 0.279821;,
    -0.707107; 0.649384; 0.279821;,
    -0.447213; 0.821413; 0.353949;,
    -1.000000; -0.000000; -0.000000;,
    0.707107; 0.649384; 0.279822;,
    0.447214; 0.821413; 0.353949;,
    1.000000; 0.000000; 0.000000;,
    0.279822; 0.649384; -0.707107;,
    0.353950; 0.821413; -0.447213;,
    0.353950; 0.821413; 0.447214;,
    0.279822; 0.649384; 0.707107;,
    0.279822; 0.649384; 0.707107;,
    0.000000; 0.000000; 1.000000;,
    0.353950; 0.821413; 0.447214;,
    0.000000; -0.000000; -1.000000;,
    0.353950; 0.821413; -0.447213;,
    0.279822; 0.649384; -0.707107;;
    26;
    3;0, 1, 2;,
    3;1, 3, 2;,
    3;4, 5, 6;,
    3;4, 7, 5;,
    3;8, 9, 10;,
    3;11, 8, 10;,
    3;12, 13, 14;,
    3;14, 13, 15;,
    3;16, 17, 18;,
    3;19, 17, 16;,
    3;20, 21, 22;,
    3;20, 23, 21;,
    3;24, 25, 26;,
    3;27, 28, 29;,
    3;30, 31, 32;,
    3;33, 31, 30;,
    3;34, 35, 36;,
    3;37, 38, 39;,
    3;40, 41, 42;,
    3;41, 43, 42;,
    3;44, 45, 46;,
    3;47, 48, 49;,
    3;50, 51, 52;,
    3;51, 53, 52;,
    3;54, 55, 56;,
    3;57, 58, 59;;
   }

   MeshTextureCoords {
    60;
    0.998539; 0.243818;,
    0.998539; 0.120663;,
    0.880585; 0.243818;,
    0.880585; 0.120663;,
    0.336679; 0.215759;,
    0.596945; 0.003760;,
    0.285091; 0.003760;,
    0.545357; 0.215759;,
    0.057225; 0.004244;,
    0.003363; 0.215676;,
    0.328967; 0.215676;,
    0.275104; 0.004244;,
    0.547838; 0.217921;,
    0.339161; 0.217921;,
    0.599426; 0.429920;,
    0.287573; 0.429920;,
    0.005098; 0.218182;,
    0.276841; 0.429614;,
    0.330703; 0.218182;,
    0.058961; 0.429614;,
    0.818378; 0.001068;,
    0.744514; 0.252699;,
    0.818378; 0.252699;,
    0.744514; 0.001068;,
    0.628731; 0.000849;,
    0.737160; 0.000849;,
    0.737160; 0.252480;,
    0.819383; 0.001329;,
    0.927812; 0.001330;,
    0.819383; 0.252960;,
    0.732954; 0.257943;,
    0.984584; 0.331806;,
    0.732954; 0.331806;,
    0.984584; 0.257943;,
    0.690249; 0.189874;,
    0.581821; 0.189874;,
    0.690249; 0.441505;,
    0.983814; 0.441039;,
    0.983814; 0.332611;,
    0.732184; 0.332611;,
    0.984584; 0.331806;,
    0.984584; 0.257943;,
    0.732954; 0.331806;,
    0.732954; 0.257943;,
    0.690249; 0.441505;,
    0.581821; 0.189874;,
    0.690249; 0.189874;,
    0.983814; 0.441039;,
    0.732184; 0.332611;,
    0.983814; 0.332611;,
    0.818378; 0.252699;,
    0.818378; 0.001068;,
    0.744514; 0.252699;,
    0.744514; 0.001068;,
    0.628731; 0.000849;,
    0.737160; 0.000849;,
    0.737160; 0.252480;,
    0.819383; 0.001329;,
    0.927812; 0.001330;,
    0.819383; 0.252960;;
   }

   MeshVertexColors {
    60;
    0; 1.000000; 1.000000; 1.000000; 1.000000;,
    1; 1.000000; 1.000000; 1.000000; 1.000000;,
    2; 1.000000; 1.000000; 1.000000; 1.000000;,
    3; 1.000000; 1.000000; 1.000000; 1.000000;,
    4; 1.000000; 1.000000; 1.000000; 1.000000;,
    5; 1.000000; 1.000000; 1.000000; 1.000000;,
    6; 1.000000; 1.000000; 1.000000; 1.000000;,
    7; 1.000000; 1.000000; 1.000000; 1.000000;,
    8; 1.000000; 1.000000; 1.000000; 1.000000;,
    9; 1.000000; 1.000000; 1.000000; 1.000000;,
    10; 1.000000; 1.000000; 1.000000; 1.000000;,
    11; 1.000000; 1.000000; 1.000000; 1.000000;,
    12; 1.000000; 1.000000; 1.000000; 1.000000;,
    13; 1.000000; 1.000000; 1.000000; 1.000000;,
    14; 1.000000; 1.000000; 1.000000; 1.000000;,
    15; 1.000000; 1.000000; 1.000000; 1.000000;,
    16; 1.000000; 1.000000; 1.000000; 1.000000;,
    17; 1.000000; 1.000000; 1.000000; 1.000000;,
    18; 1.000000; 1.000000; 1.000000; 1.000000;,
    19; 1.000000; 1.000000; 1.000000; 1.000000;,
    20; 1.000000; 1.000000; 1.000000; 1.000000;,
    21; 1.000000; 1.000000; 1.000000; 1.000000;,
    22; 1.000000; 1.000000; 1.000000; 1.000000;,
    23; 1.000000; 1.000000; 1.000000; 1.000000;,
    24; 1.000000; 1.000000; 1.000000; 1.000000;,
    25; 1.000000; 1.000000; 1.000000; 1.000000;,
    26; 1.000000; 1.000000; 1.000000; 1.000000;,
    27; 1.000000; 1.000000; 1.000000; 1.000000;,
    28; 1.000000; 1.000000; 1.000000; 1.000000;,
    29; 1.000000; 1.000000; 1.000000; 1.000000;,
    30; 1.000000; 1.000000; 1.000000; 1.000000;,
    31; 1.000000; 1.000000; 1.000000; 1.000000;,
    32; 1.000000; 1.000000; 1.000000; 1.000000;,
    33; 1.000000; 1.000000; 1.000000; 1.000000;,
    34; 1.000000; 1.000000; 1.000000; 1.000000;,
    35; 1.000000; 1.000000; 1.000000; 1.000000;,
    36; 1.000000; 1.000000; 1.000000; 1.000000;,
    37; 1.000000; 1.000000; 1.000000; 1.000000;,
    38; 1.000000; 1.000000; 1.000000; 1.000000;,
    39; 1.000000; 1.000000; 1.000000; 1.000000;,
    40; 1.000000; 1.000000; 1.000000; 1.000000;,
    41; 1.000000; 1.000000; 1.000000; 1.000000;,
    42; 1.000000; 1.000000; 1.000000; 1.000000;,
    43; 1.000000; 1.000000; 1.000000; 1.000000;,
    44; 1.000000; 1.000000; 1.000000; 1.000000;,
    45; 1.000000; 1.000000; 1.000000; 1.000000;,
    46; 1.000000; 1.000000; 1.000000; 1.000000;,
    47; 1.000000; 1.000000; 1.000000; 1.000000;,
    48; 1.000000; 1.000000; 1.000000; 1.000000;,
    49; 1.000000; 1.000000; 1.000000; 1.000000;,
    50; 1.000000; 1.000000; 1.000000; 1.000000;,
    51; 1.000000; 1.000000; 1.000000; 1.000000;,
    52; 1.000000; 1.000000; 1.000000; 1.000000;,
    53; 1.000000; 1.000000; 1.000000; 1.000000;,
    54; 1.000000; 1.000000; 1.000000; 1.000000;,
    55; 1.000000; 1.000000; 1.000000; 1.000000;,
    56; 1.000000; 1.000000; 1.000000; 1.000000;,
    57; 1.000000; 1.000000; 1.000000; 1.000000;,
    58; 1.000000; 1.000000; 1.000000; 1.000000;,
    59; 1.000000; 1.000000; 1.000000; 1.000000;;
   }

   MeshMaterialList {
    1;
    26;
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
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

    Material Texture_Grenade_Launcer {
     0.588000; 0.588000; 0.588000; 1.000000;;
     128.000000;
     0.000000; 0.000000; 0.000000;;
     0.000000; 0.000000; 0.000000;;

     TextureFilename {
      "grenade_Launcer_diff.TGA";
     }
    }

   }
  }
}