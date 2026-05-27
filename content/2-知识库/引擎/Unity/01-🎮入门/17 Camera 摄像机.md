# 📷 17 Camera 摄像机

**所属模块**：[[00 Unity入门阶段总览]]
**关联**：[[03 Unity中的坐标系]] | [[16 Screen 屏幕]]
**查阅次数**：0

---

## Camera 可编辑参数

- **Clear Flags  
    如何清除背景
    - skybox 天空盒
    - Solid Color 颜色填充
    - Depth only 只画该层 背景透明  
        多摄像机 叠加显示
    - Don't Clear 不移除 覆盖渲染
- **Culling Mask  
    选择性渲染部分层级
    - 可以指定只渲染对应层级的对象
- **Projection
    - Perspective 透视模式  
        进大远小
        - FOV Axis  
            视场角 轴  
            决定光学仪器的视野范围
        - Field of view  
            视口大小
        - Physical Camera  
            物理摄像机
            - Focal Length  
                焦距
            - Sensor Type  
                传感器类型
            - Sensor Size  
                传感器尺寸
            - Lens Shift  
                透镜移位
            - Gate Fit  
                闸门配合
    - orthographic 正交摄像机  
        一般用于2D游戏操作
        - Size  
            摄制范围
- **ClippingPlanes  
    裁剪平面距离  
    最近能看多进 最远能看多远
- Viewport Rect  
    视口范围  
    屏幕上将绘制该摄像机视图的位置
    - 主要用于双摄相机游戏
    - 0~1相当于宽高百分比
- **Depth  
    渲染顺序上的深度  
    数字越小越先被渲染  
    先被渲染的会被后被渲染的覆盖
- Redering path  
    渲染路径
- **Target Texture  
    渲染纹理
    - 可以把摄像机画面渲染到一张图上
    - 在Project右键创建 Render Texture
    - 主要用于制作小地图
- **Occlusion Culling  
    是否启用剔除遮挡
    - 被挡住的模型不被渲染
- Allow HDR  
    是否允许高动态范围渲染
- Allow MSAA  
    是否允许抗锯齿
- Allow Dynamic Resolution  
    是否允许动态分辨率呈现
- Target Display  
    用于哪个显示器
- Target Eye  
    VR显示相关
---

## Camera 代码操作

---

### 重要静态成员

```csharp
// 获取主摄像机（标签为 MainCamera）主摄像机标签一定要是MainCamera 不然会得到空
Camera.main

// 摄像机数量
Camera.allCamerasCount
Camera.allCameras

// 摄像机渲染事件
Camera.onPreCull += 函数;   // 摄像机剔除前处理的委托函数
Camera.onPreRender += 函数;  // 摄像机渲染前处理的委托
Camera.onPostRender += 函数; // 摄像机渲染后处理的委托
```

---

### 重要成员

**注意：**
- 如果不改z轴 默认为0
- 转换过去的世界坐标系的点 永远都是一个点 即视口相交的焦点
- 如果改变了z 那么转换过去的 世界坐标系的点 就是相对于 摄像机前方多少的单位的横截面上面的世界坐标点

```csharp
// 界面上的参数都可以通过代码获取
Camera.main.fieldOfView = 60;
Camera.main.orthographicSize = 5;
//...

// 世界坐标 → 屏幕坐标 可以做头顶血条相关功能
// xy对应屏幕坐标 z对应3D物体离摄像机的距离
Vector3 screenPos = Camera.main.WorldToScreenPoint(worldPos);

// 屏幕坐标 → 世界坐标（需要设置 z 值为距摄像机的距离）
Vector3 mousePos = Input.mousePosition;
mousePos.z = 50;  // 距摄像机 50 单位
Vector3 worldPos = Camera.main.ScreenToWorldPoint(mousePos);
```

---

## 练习

> 1. 请用两个摄像机实现分屏效果：一个摄像机俯视坦克跟随移动，一个摄像机在炮口位置跟随坦克炮口移动

```csharp
操作步骤：
1. 创建两个摄像机 Camera_Top 和 Camera_Gun
2. Camera_Top：Viewport Rect 设置上半屏（X=0, Y=0.5, W=1, H=0.5），挂跟随脚本
3. Camera_Gun：Viewport Rect 设置下半屏（X=0, Y=0, W=1, H=0.5），设为炮口子对象
//[[练习20操作.png]]
```

> 2. 场景上有两个物体 A 和 B，有两个摄像机 A 和 B，A 摄像机渲染 A，B 摄像机渲染 B，玩家能在 Game 窗口同时看到 A 和 B

```csharp
操作步骤：
1. 设置对象 A 在 Layer "LayerA"，对象 B 在 Layer "LayerB"
2. 摄像机 A 的 Culling Mask 只勾选 "LayerA"，Depth = 0，Viewport Rect 覆盖全屏
3. 摄像机 B 的 Culling Mask 只勾选 "LayerB"，Depth = 1，Clear Flags = Depth Only
//[[练习20面板设置1.png]] [[练习20面板设置2.png]] 
```

> 3. 游戏画面中央有一个立方体，请将该立方体的世界坐标系位置，转换为屏幕坐标，并打印出来

```csharp
public class Test9 : MonoBehaviour
{
    void Start()
    {
        print(Camera.main.WorldToScreenPoint(transform.position));
    }
}
```

> 4. 在屏幕上点击一下鼠标，则在对应的世界坐标位置创建一个 Cube 出来

```csharp
public class Test9 : MonoBehaviour
{
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            GameObject obj = GameObject.CreatePrimitive(PrimitiveType.Cube);
            Vector3 v = Input.mousePosition;
            v.z = 50;  // 距摄像机的距离
            obj.transform.position = Camera.main.ScreenToWorldPoint(v);
        }
    }
}
```

---

## 我的踩坑记录

- 做分屏时，Viewport Rect 的 Y 轴是从下到上（0在下，1在上）

---

*最后更新：*
