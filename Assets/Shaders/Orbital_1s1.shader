Shader "Orbital/1s1"
{
	/**
	*	Shejder za vezhbanje i testiranje, shta ovde uspe ide u posebne, korisne
	*/

	Properties
	{
		_Color ("Color", Color ) = (1,1,1,0)
		_Gloss ("Gloss", float ) = 1
		_Alpha ("Alpha", Range(0, 1)) = 0.25

		_LinesTex("LinesTex", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "Queue"="AlphaTest" "RenderType"="Transparent" }
		LOD 100

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha // PROVERI SHTA OVO TACHNO RADI
		//Blend One OneMinusSrcAlpha


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc" // helper functions
			#include "Lighting.cginc"

			// Mesh data given to vertex shader
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv0 : TEXCOORD0;
			};

			// _Vertex_ data given to fragment shader
			struct v2f
			{
				UNITY_FOG_COORDS(1) // wat?
				float4 vertex : SV_POSITION; // SV(screen space) clip space position, local space from mesh data
				float2 uv0 : TEXCOORD0;
				float3 normal : NORMAL;
				float3 worldPos: TEXCOORD2;
			};


			uniform float4 _Color;
			float _Gloss;
			uniform float3 _MousePos;
			uniform float	_Alpha;
			
			sampler2D _LinesTex;
			 
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); // to clip shader
				o.normal = v.normal;
				o.worldPos = mul( unity_ObjectToWorld, v.vertex); // vector multiplciation -> from local to world space
				o.uv0 = v.uv0; //TRANSFORM_TEX(v.uv, _MainTex); <- appling tiling and offset params (from editor)

				return o;
			}

			// value = lerp(a, b, t)
			float3 MyLerp( float3 a, float3 b, float t) {
				return t * b + (1.0 - t) * a;
			}

			// t = invLerp(a, b, value)
			float3 MyInverseLerp( float a, float b, float value) {
				return (value - a) / (b - a);
			}

			float Posterize( float steps, float value ) {
				return floor(value * steps) / steps;
			}
			
			float PositiveSinCos(float sinCos) {
				return (sinCos + 1) * 0.5;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float4 black = float4(0, 0, 0, 0);
				float4 white = float4(1, 1, 1, 1);


				float dist = distance(_MousePos, i.worldPos)/10;

				float glow = saturate( 1-dist);

				float2 uv =  i.uv0;
				float3 normal = normalize(i.normal); // * 0.5 + 0.5 move (-1 to 1) to (0 to 1) =

				float3 colorA = float3(0.1, 0.8, 1);
				float3 colorB = float3(0.7, 0.1, 3);

				float t = uv.y;

				t = Posterize(16, t);

				float3 blend = MyLerp(colorA, colorB, t);

				// return float4(blend, 0);

				// Lighting
				// Direct diffuse
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 lightColor = _LightColor0.rgb;
				float lightFalloff = max(0, dot(lightDir, normal));
				// lightFalloff = Posterize(3, lightFalloff);
				float3 directDiffuseLight = lightColor * lightFalloff;
				// Ambient
				float3 ambientLight = float3(0.2, 0.1, 0.3);

				// Direct specular
				float3 camPos = _WorldSpaceCameraPos;
				float3 fragToCam = camPos - i.worldPos;
				float3 viewDir = normalize(fragToCam);
				float3 viewReflection = reflect(-viewDir, normal);

				float specularFalloff = max(0, dot(viewReflection, lightDir));
				specularFalloff = pow( specularFalloff, _Gloss );
				// specularFalloff = Posterize(3, specularFalloff);
				float3 directSpecular = specularFalloff * lightColor;

				// Composite
				float3 diffuseLight = ambientLight + directDiffuseLight;
				float3 finalSurfaceColor = diffuseLight * _Color.rgb + directSpecular;

				float3 finalRGB = finalSurfaceColor;

				float alpha = 1;
				//float2 horizontalNormalDiff = abs(normalize(fragToCam.xz) - normalize(i.normal.xz));
				//float wave = length(sin(_Time.y + horizontalNormalDiff));
				//float alpha = (wave / 4) + PositiveSinCos(sin( _Time.y * 10) / 2);


				float lines = tex2D(_LinesTex, i.uv0).x;

				alpha = lines;// saturate(wave);

				fixed4 result = fixed4(finalRGB, alpha);


				return result;
			}
			ENDCG
		}
	}
}
