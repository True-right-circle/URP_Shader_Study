// Shader ����. ���̴��� ������ �̸��� ���⼭ �����մϴ�.
//Shader "URPTraining/URPBasic" //-> ���̴� �̸��� ���̴� ���� ���� �ٸ� �� �ִ� ����� ���̴� �̸� : ���͸��󿡼� �����ϴ� �����̸�/�����̸�
//�ߺ� �Ǹ� �ȳ��� ���� �ִ� ����
Shader "URPBasic"
{
	Properties //���� ����
	{
		// Properties Block : ���̴����� ����� ������ �����ϰ� �̸� material inspector�� �����ŵ�ϴ�
		//���̴� ��꿡 ��� �Ǵ� �������� �����ϴ°�
		//�������� �θ� ��� �Ǵ� �̸����� �������
		//Color �ȷ�Ʈ�� ����Ѵ� ���� => R,G,B,A
		//�ν����� â�� Color �ȷ�Ʈ�� �߰� �ȴ�
		//���� �� ������ ���̴� �ȿ��� ���Ǹ� ������Ѵ� -1.1
		_TintColor("Color",color)=(1,1,1,1)
		_Intensity("Range Sample", Range(0,1)) = 0.5 //�̰��� ���� Color�� ���� ������ �ν����� â�� �����ش�

		//�ؽ��� ���ø�
		//���� �� ������ ���̴� �ȿ��� ���Ǹ� ������Ѵ� -1.2
		_MainTex("Main Texture", 2D) = "white"{}
	}

	SubShader // ���̴� ���� ���� �ϴ°�
	{
		//����Ƽ�� �޽��� �׸� �� ��ȣ�� �ٿ� ���� ��� �׸���
		//Geometry
		//alphatest
		//zpass
		Tags //���̴��� Ÿ���� ���� � �� �ִ�
		{
			//Render type�� Render Queue�� ���⼭ �����մϴ�.
		   "RenderPipeline" = "UniversalPipeline" // URP�̹Ƿ� UniversalPipeline�� ����
			"RenderType" = "Opaque" //
			"Queue" = "Geometry" // �׸��� ������ �������� ����
			//Fromshader �ɼ��� ���⿡ ���� �� ����ť�� �����Ѵ�.

		}

		Pass // 
		{
			Name "Universal Forward"
			Tags { "LightMode" = "UniversalForward" }
			
			HLSLPROGRAM //����Ѵ� ��������(legacy) CG�� ��������� URP���� HLSL�� ����Ѵ� - ����

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma vertex vert
			#pragma fragment frag

			//cg shader�� .cginc�� hlsl shader�� .hlsl�� include�ϰ� �˴ϴ�.
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"        	
			
			//���� �������������� �ٷ�9 ������������ ���󰣴�
	
			//vertex buffer���� �о�� ������ �����մϴ�. 	
			//������Ʈ �޽��� ����ִ� ������ �����´� � ������ �������� �����ϴ°�
			struct VertexInput
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			//�����⸦ ���� ���ؽ� ���̴����� �ȼ� ���̴��� ������ ������ �����մϴ�.
			//������� ���ؽ� ���̴����� ���� ������ �ȼ� ���̴��� �������ִ� �������Ѵ�
			//�������� ���ڴ� ����ȭ�� ������ ��ģ��
			struct VertexOutput
			{
				float4 vertex  	: SV_POSITION; //��� �� pos��
				float2 uv : TEXCOORD0;
			};

			//-1.1 ����
			half4 _TintColor;
			float _Intensity;
			
			//-1.2 ����
			sampler2D _MainTex;
			float4 _MainTex_ST;

			//half4 - color ���� �� ����,float -> �� �� ������ ������ ����� �� ���(range��)
			//fixed4 -> HLSL������ ��� ���Ѵ�. 

			//���ؽ� ���̴� 
			VertexOutput vert(VertexInput v) 
			{
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz); //���� ��ġ�� TransformObjectToHClip�� ���ؼ� o�� ������ ���� �־� �ȼ� ���̴��� �ѱ��.
				o.uv = v.uv;
				return o;
			}
			
			//�ȼ� ���̴�
			//i�� ���� ���ؽ� ���̴����� ���� ���� ����Ѵ�
			half4 frag(VertexOutput i) : SV_Target
			{
				float2 uv = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;

				//���� �� _TintColor�� _Intensity�� ���ؽ� ���̴��� ���ؼ� �ν����� â���� ���� ��ȯ ��ų �� �ִ�
				float4 color = tex2D(_MainTex, uv) * _TintColor * _Intensity;
				return color;
			}

		ENDHLSL //-��
		}
	}
}
