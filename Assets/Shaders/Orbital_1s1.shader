Shader "Orbital/1s1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color ) = (1,1,1,0)
		_Gloss ("Gloss", float ) = 1
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
				float4 vertex : SV_POSITION; // clip space position, local space from mesh data
				float2 uv0 : TEXCOORD0;
				float3 normal : NORMAL;
				float3 worldPos: TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			uniform float4 _Color;
			float _Gloss;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); // to clip shader
				o.normal = v.normal;
				o.worldPos = mul( unity_ObjectToWorld, v.vertex); // vector multiplciation -> from local to world space
				o.uv0 = v.uv0; //TRANSFORM_TEX(v.uv, _MainTex);

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
			
			fixed4 frag (v2f i) : SV_Target
			{

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
				lightFalloff = Posterize(8, lightFalloff);
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
				specularFalloff = Posterize(8, specularFalloff);
				float3 directSpecular = specularFalloff * lightColor;

				// Phong



				// Composite
				float3 diffuseLight = ambientLight + directDiffuseLight;
				float3 finalSurfaceColor = diffuseLight * _Color.rgb + directSpecular;

				float3 finalRGB = finalSurfaceColor;

				return fixed4( finalRGB, 0);
			}
			ENDCG
		}
	}
}
