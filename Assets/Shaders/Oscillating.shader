Shader "Moleqlix/Oscillating"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,0)
        _NumberOfWaves("Number of waves", Range(1, 10)) = 5
        _BaseSpeed("Base Speed", Range(-10,10)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 worldPos: TEXCOORD2;
            };

            uniform float4 _Color;
            uniform float _BaseSpeed;
            uniform float _NumberOfWaves;


            float PositiveSinCos(float sinCos) {
                return (sinCos + 1) * 0.5;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv0;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float frequency = 8 * _NumberOfWaves;
                float4 col = PositiveSinCos( sin((i.uv.y * frequency + (_Time.y * _BaseSpeed))));
                col *= _Color;

                return col;
            }
            ENDCG
        }
    }
}
