Shader "Custom/River" {
	Properties{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
	_WhiteRange("WhiteRange",float) = 0.7

		_USpeed("USpeed ", float) = 1.0
		_UCount("UCount", float) = 1.0
		_VSpeed("VSpeed", float) = 1.0
		_VCount("VCount", float) = 1.0
	}

		SubShader{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True"      "RenderType" = "Transparent" }
		ColorMask 0

		CGPROGRAM
#pragma surface surf Lambert alpha
		sampler2D _MainTex;
	fixed4 _Color;
	float _WhiteRange;

	// U轴方向滚动速度
	float _USpeed;
	// U轴方向平铺个数
	float _UCount;

	// V轴方向滚动速度
	float _VSpeed;
	// V轴方向平铺个数
	float _VCount;
	struct Input {
		float2 uv_MainTex;
	};

	void surf(Input IN, inout SurfaceOutput o) {
		fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

		float2 uv = IN.uv_MainTex;
		float detalTime = _Time.x;

		//  计算X轴方向变化
		uv.x -= detalTime * _USpeed;
		uv.x *= _UCount;

		// 计算Y轴方向变化
		uv.y += detalTime * _VSpeed;
		uv.y *= _VCount;

		half4 c2 = tex2D(_MainTex, uv);
		o.Albedo = c2.rgb;
		o.Alpha = c2.a;

		o.Albedo = c2.rgb;

		if (c2.r >= _WhiteRange && c2.g >= _WhiteRange && c2.b >= _WhiteRange)//判断RGB的值接近白色//
		{
			o.Alpha = 0;
		}
		else
		{
			o.Alpha = 1;
		}
		o.Emission = c2 * _Color;

	}
	ENDCG
	}

		Fallback "Legacy Shaders/Transparent/VertexLit"
}