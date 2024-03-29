﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/pixelate"
{
    Properties
    {
        _CellSize ("Cell Size", Vector) = (0.02, 0.02, 0, 0)
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque" "Queue" = "Transparent"
        }
        LOD 200

        GrabPass
        {
            "_PixelationGrabTexture"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                half4 pos : SV_POSITION;
                half4 grabUV : TEXCOORD0;
            };

            half4 _CellSize;

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.grabUV = ComputeGrabScreenPos(o.pos);
                return o;
            }

            sampler2D _PixelationGrabTexture;

            half4 frag(v2f IN) : COLOR
            {
                half2 steppedUV = IN.grabUV.xy / IN.grabUV.w;
                steppedUV /= _CellSize.xy;
                steppedUV = round(steppedUV);
                steppedUV *= _CellSize.xy;
                return tex2D(_PixelationGrabTexture, steppedUV);
            }
            ENDCG
        }
    }
}