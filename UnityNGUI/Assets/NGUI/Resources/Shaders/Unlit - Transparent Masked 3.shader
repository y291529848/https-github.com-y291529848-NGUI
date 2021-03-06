// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Unlit/Transparent Masked 3"
{
	Properties
	{
		_MainTex("Base (RGB), Alpha (A)", 2D) = "black" {}
	_AlphaTex("alpha tex",2D) = "white"{}
	_Mask("Alpha (A)", 2D) = "white" {}
	}

		SubShader
	{
		LOD 200

		Tags
	{
		"Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
	}

		Pass
	{
		Cull Off
		Lighting Off
		ZWrite Off
		Fog{ Mode Off }
		Offset -1, -1
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag			
#include "UnityCG.cginc"

		sampler2D _MainTex;
	sampler2D _Mask;
	float4 _MainTex_ST;
	sampler2D _AlphaTex;
	float4 _AlphaTex_ST;
	struct appdata_t
	{
		float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
		float2 texcoord1 : TEXCOORD1;
		fixed4 color : COLOR;
	};

	struct v2f
	{
		float4 vertex : SV_POSITION;
		float2 texcoord : TEXCOORD0;
		float2 texcoord1 : TEXCOORD1;
		fixed4 color : COLOR;
	};

	v2f o;

	v2f vert(appdata_t v)
	{
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.texcoord = v.texcoord;
		o.texcoord1 = v.texcoord1;
		o.color = v.color;
		return o;
	}

	fixed4 frag(v2f IN) : COLOR
	{
		half4 col = tex2D(_MainTex, IN.texcoord) * IN.color;
		col.a *= tex2D(_Mask, IN.texcoord1).a;
		fixed4 result = col;
		result.a = tex2D(_AlphaTex, IN.texcoord).r*IN.color.a;
		return col;
	}
		ENDCG
	}
	}

		SubShader
	{
		LOD 100

		Tags
	{
		"Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
	}

		Pass
	{
		Cull Off
		Lighting Off
		ZWrite Off
		Fog{ Mode Off }
		Offset -1, -1
		ColorMask RGB
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMaterial AmbientAndDiffuse

		SetTexture[_MainTex]
	{
		Combine Texture * Primary
	}
	}
	}
}
