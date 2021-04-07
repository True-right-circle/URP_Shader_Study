// Shader 시작. 셰이더의 폴더와 이름을 여기서 결정합니다.
//Shader "URPTraining/URPBasic" //-> 쉐이더 이름과 쉐이더 파일 명은 다를 수 있다 현재는 쉐이더 이름 : 메터리얼에서 선택하는 폴더이름/파일이름
//중복 되면 안나올 수도 있다 주의
Shader "URPBasic"
{
	Properties //변수 선언
	{
		// Properties Block : 셰이더에서 사용할 변수를 선언하고 이를 material inspector에 노출시킵니다
		//쉐이더 계산에 사용 되는 변수들을 선언하는것
		//변수명은 널리 통용 되는 이름으로 사용하자
		//Color 팔레트를 사용한다 선언 => R,G,B,A
		//인스펙터 창에 Color 팔레트가 추가 된다
		//선언 된 변수를 쉐이더 안에서 정의를 해줘야한다 -1.1
		_TintColor("Color",color)=(1,1,1,1)
		_Intensity("Range Sample", Range(0,1)) = 0.5 //이값은 위의 Color의 범위 지정을 인스펙터 창에 보여준다

		//텍스쳐 샘플링
		//선언 된 변수를 쉐이더 안에서 정의를 해줘야한다 -1.2
		_MainTex("Main Texture", 2D) = "white"{}
	}

	SubShader // 쉐이더 블럭을 선언 하는것
	{
		//유니티는 메쉬를 그릴 때 번호를 붙여 순서 대로 그린다
		//Geometry
		//alphatest
		//zpass
		Tags //쉐이더의 타입을 선언 몇개 더 있다
		{
			//Render type과 Render Queue를 여기서 결정합니다.
		   "RenderPipeline" = "UniversalPipeline" // URP이므로 UniversalPipeline로 선언
			"RenderType" = "Opaque" //
			"Queue" = "Geometry" // 그리는 순서는 무엇인지 설정
			//Fromshader 옵션은 여기에 선언 된 렌더큐를 선택한다.

		}

		Pass // 
		{
			Name "Universal Forward"
			Tags { "LightMode" = "UniversalForward" }
			
			HLSLPROGRAM //사용한다 이전에는(legacy) CG를 사용했지만 URP에선 HLSL를 사용한다 - 시작

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma vertex vert
			#pragma fragment frag

			//cg shader는 .cginc를 hlsl shader는 .hlsl을 include하게 됩니다.
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"        	
			
			//렌더 파이프라인으느 다렉9 파이프라인을 따라간다
	
			//vertex buffer에서 읽어올 정보를 선언합니다. 	
			//오브젝트 메쉬에 들어있는 정보를 가져온다 어떤 정보를 가져올지 선언하는것
			struct VertexInput
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			//보간기를 통해 버텍스 셰이더에서 픽셀 셰이더로 전달할 정보를 선언합니다.
			//보간기는 버텍스 쉐이더에서 얻은 정보를 픽셀 쉐이더로 전달해주는 역할을한다
			//보간기의 숫자는 최적화에 영향을 끼친다
			struct VertexOutput
			{
				float4 vertex  	: SV_POSITION; //계산 된 pos값
				float2 uv : TEXCOORD0;
			};

			//-1.1 선언
			half4 _TintColor;
			float _Intensity;
			
			//-1.2 선언
			sampler2D _MainTex;
			float4 _MainTex_ST;

			//half4 - color 관련 된 값들,float -> 좀 더 정교한 값들을 사용할 때 사용(range등)
			//fixed4 -> HLSL에서는 사용 못한다. 

			//버텍스 셰이더 
			VertexOutput vert(VertexInput v) 
			{
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz); //점의 위치를 TransformObjectToHClip를 통해서 o에 포지션 값을 넣어 픽셀 셰이더로 넘긴다.
				o.uv = v.uv;
				return o;
			}
			
			//픽셀 셰이더
			//i를 통해 버텍스 셰이더에서 받은 값을 사용한다
			half4 frag(VertexOutput i) : SV_Target
			{
				float2 uv = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;

				//선언 된 _TintColor와 _Intensity로 버텍스 쉐이더를 통해서 인스텍터 창으로 색을 변환 시킬 수 있다
				float4 color = tex2D(_MainTex, uv) * _TintColor * _Intensity;
				return color;
			}

		ENDHLSL //-끝
		}
	}
}
