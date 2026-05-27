# 13 LineRenderer

**所属模块**：[[00 Unity 基础阶段总览]]
**关联**：[[11 MonoBehavior 重要内容]] | [[16 补充内容]]
**查阅次数**：0

---

## 核心理解

> LineRenderer是Unity提供的一个用于画线的资源，使用它可以在场景中绘制线段

**作用：**
- 绘制攻击范围
- 武器红外线
- 辅助功能
- 其他画线功能

---

## 参数

- 编辑模式
	- Line Rendered
	  开关编辑模式 左侧编辑点 右侧添加点
		- 无编辑操作
			- Simplify Preview
			  简化预览
			- Tolerance
			  宽容度 偏移值越大 偏差越大
		- 编辑点模式
			- Show Wireframe
			  显示线框
			- Subdvide Selected
			  细分选项 选择两个或多个相邻点时 该按钮启用 会在相邻点之间插入一个新点
		- 添加点模式
			- Input
			  输入模式
				- Mouse Position
				  鼠标位置 在面前创建一个点 效果不好
				- Physice Raycast
				  基于物理射线
					- LayerMask
					  哪些层检测射线
				- Min Vertex Distance
				  最小顶点距离 拖动鼠标创建点时 会在超出该距离时创建一个点
				- Offset
				  偏移量
- **Loop**
  是否首位自动相连
- Positions
  线段的点
	- Size
	  点的数量
- **线段弯度曲线调整**
	- Width 线的粗细
	- 右键Add 添加节点 拖动改变曲线
- **Color**
  颜色变化
	- Mode
	  模式 可以调节渐变色
- **Corner Vertices**
  角顶点的圆角值 此属性表示在一条线中绘制角时使用了多少额外的顶点 
  增加此值，使线角看起来更圆
- **End Cap Vertices**
  起点和终点的 圆角值
- Alignmen
  对齐方式
	- View
	  视点 线段对着摄像机
	- Transform Z
	  线段面向其Z轴
- Texture Mode
  纹理模式
	- Stretch
	  拉伸 沿整条线映射纹理一次
	- Tile
	  瓷砖平铺 不停重复纹理
	- Distribute Per Segment
	  分配执行
	- Repeat Per Segment
	  重复显示
- Shadow Rias
  阴影偏移
- Generate Lighting Data
  生成光源数据
- **Use World Space**
  是否使用世界坐标系
- **Materials**（材质球是一个资源类型 可以新建）
  线使用的材质球
- Lighting
  光照影响
	- Cast Shadows
	  是否开启阴影
	- Receive Shadows
	  接收阴影
- Probes
  光照探针
	- Light Probes
	  光探测器模式
		- Off
		- Blend Probes
		  使用内插光探针
		- Use Proxy Volume
		  使用三维网格内插光探针
		- Custom Provided
		  自定义从材质决定
	- Reflection Probes
	- 反射探测器模式
		- Off
		- Blend Probes
		  启用混合反射探针
		- Blend Probes And Skybox
		  启用混合反射探针 并且和天空盒混合
		- Simple
		  启用普通探针 重叠式钚混合
- Additional Settings
  附加设置
	- Motion Vectors
	  运动矢量
		- Camera Motion Only
		  使用相机运动来跟踪运动
		- Per Object Motion
		  通过特定对象来跟踪运动
		- Force No Motion
		  不跟踪
	- Dynamic Occludee
	  动态遮挡剔除
	- Sorting Layer
	  排序图层
	- Order in Layer
	  此线段在排序图层中的顺序

---

## 代码

```csharp
//1 动态添加一个线段
GameObject line = new GameObject();//实例化一个空对象
Line.name = "Line";//改名
LineRenderer lineRenderer = Line.AddComponent<LineRenderer>();//给空对象添加脚本

//2 首位相连 可以点出来脚本面板信息直接用
lineRenderer.loop = true;

//3 开始宽 结束宽
lineRenderer.startWidth = 0.02f;
lineRenderer.endWidth = 0.02f;

//4 开始结束颜色
lineRenderer.startColor = Color.white;
lineRenderer.endColor = Color.red;

//5 设置材质
private Material m;
m = ...;
lineRenderer.meterial = m;

//6 设置点 注意：要先设置点的个数
lineRenderer.positionCount = 4;
//设置每个点对应的位置 点没有赋值默认的位置是 (0, 0, 0) 
lineRenderer.SetPosition(new Vector3[] { new Vector3(0, 0, 0), new Vector3(0, 0, 5), new Vector3(5, 0, 5) });
//指定设置点 第一个参数索引
lineRenderer.SetPosition(lineRenderer.positionCount - 1, new Vector3(5, 0, 0))

//7 是否使用世界坐标系
lineRenderer.useWorldSpace = false;

//8 让线段受光影响 会接受光数据 进行着色器计算
lineRenderer.generateLightingData = true;
```

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- 场景一：
- 场景二：
- 反例（不该用的时候）：

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

---

## 练习

> 1. 请写一个方法，传入一个中心点，传入一个半径，用LineRender画一个圆出来

```csharp
public class LineRenderer_Sphere : MonoBehaviour
{
    private LineRenderer lineRenderer;
    public int pointNum;
    void Start()
    {
        DrawSphereLine(Vector3.zero, 5);
    }
    public void DrawSphereLine(Vector3 center, float r)
    {
        GameObject obj = new GameObject("Line");
        lineRenderer = obj.AddComponent<LineRenderer>();
        lineRenderer.startWidth = 0.02f;
        lineRenderer.endWidth = 0.02f;
        lineRenderer.loop = true;
        lineRenderer.positionCount = pointNum;
        float angle = 360f / pointNum;
        for (int i = 0; i < pointNum; i++)
        {
            lineRenderer.SetPosition(i, center + Quaternion.AngleAxis(angle * i, Vector3.up) * Vector3.forward * r);
        }
    }
}
```

> 2. 请实现，在Game窗口长按鼠标用LineRender画出鼠标移动的轨迹

```csharp
public class LineRenderer_MouseMove : MonoBehaviour
{
    private LineRenderer line;
    private Vector3 mousePos;
    public float dis = 5;
    void Start()
    {
        line = gameObject.AddComponent<LineRenderer>();
        line.startWidth = 0.02f;
        line.endWidth = 0.02f;
        line.loop = false;
        line.positionCount = 0;
    }
    void Update()
    {
        //每次按下鼠标就新建一个新的线 就不会出现 上一次抬起鼠标最后的点与这一次按下鼠标第一次的点相连的情况
        if (Input.GetMouseButtonDown(0))
        {
            GameObject obj = new GameObject();
            line = obj.AddComponent<LineRenderer>();
            line.startWidth = 0.02f;
            line.endWidth = 0.02f;
            line.loop = false;
            line.positionCount = 0;
        }
        if (Input.GetMouseButton(0))
        {
            line.positionCount += 1;
            mousePos = Input.mousePosition;
            mousePos.z = dis;
            line.SetPosition(line.positionCount - 1, Camera.main.ScreenToWorldPoint(mousePos));
        }
    }
}
```

---

## API 速查

- LineRenderer.SetPosition （成员方法 设置点）

---

## 我的踩坑记录

> ⭐ 这里最有价值！把自己犯过的错误写下来，写上日期

- （日期）踩坑描述 → 解决方法

---

## 延伸阅读

> 这个知识点延伸出去的方向，学完后可以探索

- [[]]相关知识点
- 

---

*最后更新：*
