# 📱 16 Screen 屏幕

**所属模块**：[[00 Unity入门阶段总览]]
**关联**：[[03 Unity中的坐标系]] | [[17 Camera 摄像机]]
**查阅次数**：0

---

## 静态属性

```csharp
//常用
Screen.currentResslution //当前屏幕分辨率
Screen.width // 屏幕宽度（像素）
Screen.height // 屏幕高度（像素）

// 屏幕休眠设置（移动端）
Screen.sleepTimeout = SleepTimeout.NeverSleep;   // 永不休眠
Screen.sleepTimeout = SleepTimeout.SystemSetting; // 系统设置

//不常用
Screen.fullScreen = bool;//运行时是否全屏模式

//窗口模式相关
Screen.fullScreenMode = FullScreenMode.枚举项; //窗口模式/独占全屏/全屏窗口/最大化窗口/窗口模式
           
//移动设备屏幕转向相关       
Screen.autorotateToLandscapeLeft = bool;//允许自动旋转为左横向
Screen.autorotateToLandscapeRight = bool;//允许自动旋转为右横向  
Screen.autorotateToPortrait = bool;//允许自动旋转为纵向
Screen.autorotateToPortraitUpsideDown = bool;//允许自动旋转为纵向倒着
Screen.orientation = ScreenOrientation.枚举项//指定屏幕显示方向
```

---

## 静态方法

```csharp
//设置分辨率
Screen.SetResolutiom(宽, 高, bool); // bool 是否全屏
```

---

## 练习

> 1. 在输入习题的基础上，鼠标滚轮控制炮管的抬起放下

```csharp
public class Move_TK : MonoBehaviour
{
    public int pgSpeed = 50;
    public Transform pg;

    void Update()
    {
        pg.Rotate(Vector3.right, pgSpeed * Input.mouseScrollDelta.y * Time.deltaTime);
    }
}
```

> 2. 在上一题的基础上，加入长按鼠标右键移动鼠标可以让摄像机围着坦克旋转，改变观察坦克的视角

```csharp
public class CameraController : MonoBehaviour
{
    public int cameraSpeed = 50;
    public Transform tankPos;

    void Update()
    {
        if (Input.GetMouseButton(1))
        {
            transform.RotateAround(tankPos.position, Vector3.up,
                cameraSpeed * Input.GetAxis("Mouse X") * Time.deltaTime);
        }
    }
}
```

---

## 我的踩坑记录

-

---

*最后更新：*
