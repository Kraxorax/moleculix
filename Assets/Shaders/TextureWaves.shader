Shader "Moleqlix/TextureWaves"
{
    Properties
    {
        _ShorelineTex("Shoreline", 2D) = "black" {}
        _WaterShallow("_WaterShallow", Color) = (1,0,0,0)
        _WaterDeep("_WaterDeep", Color) = (0,1,0,0)
        _WaveColor("_WaveColor", Color) = (0,0,1,0)
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _ShorelineTex;
            uniform float3	_WaterShallow;
            uniform float3	_WaterDeep;
            uniform float3	_WaveColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float waveSize = 0.04;

                float shoreline = tex2D(_ShorelineTex, i.uv).x;
                float shape = shoreline;

                float waveAmp = (sin(shape / waveSize + -_Time.y * 4) + 1) * 0.5;

                waveAmp *= shoreline;

                float3 waterColor = lerp(_WaterDeep, _WaterShallow, shoreline);

                float3 waterWithWaves = lerp(waterColor, _WaveColor, waveAmp);

                return float4(waterWithWaves, 0);
            }
            ENDCG
        }
    }
}
