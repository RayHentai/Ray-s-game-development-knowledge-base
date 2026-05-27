# 🎮 15 Input 输入

**所属模块**：[[00 Unity入门阶段总览]]
**关联**：[[03 Unity中的坐标系]] | [[13 Time 时间]] | [[14 Transform 位移旋转缩放]]
**查阅次数**：2

---

**注意：一定写在UpDate里面**

## 鼠标输入

```csharp
// 鼠标位置（屏幕坐标，左下角为原点 往右是x正方向 往上是y轴正方向 z轴为0）
Vector3 pos = Input.mousePosition;

// 鼠标按键（0=左键 1=右键 2=中键）返回bool值
if (Input.GetMouseButtonDown(0)) // 按下瞬间（只触发一次）
if (Input.GetMouseButtonUp(0)) // 抬起瞬间（只触发一次）
if (Input.GetMouseButton(0))  // 持续按住

// 鼠标滚轮
Vector2 scroll = Input.mouseScrollDelta;  // ​y = -1 往下滚 y=0 没有滚 y= 1往上滚
```

---

## 键盘输入

```csharp
// 按下/抬起/持续 返回bool值
if (Input.GetKeyDown(KeyCode.Space)) // 按下瞬间
if (Input.GetKeyDown("space")) // 字符串方式（小写）
if (Input.GetKeyUp(KeyCode.Space)) // 抬起瞬间
if (Input.GetKey(KeyCode.Space)) // 持续按住
```

---

## 虚拟轴（推荐）

```csharp
// 返回 -1 到 1 的浮点数（有缓动，更顺滑）
float h = Input.GetAxis("Horizontal"); // A/D 或 左/右方向键
float v = Input.GetAxis("Vertical"); // W/S 或 上/下方向键
float mx = Input.GetAxis("Mouse X"); // 鼠标左右移动
float my = Input.GetAxis("Mouse Y"); // 鼠标上下移动
float ms = Input.GetAxis("Mouse ScrollWheel"); // 鼠标中键滚动

// GetAxisRaw：不缓动，直接返回 -1 / 0 / 1
float h = Input.GetAxisRaw("Horizontal");

//具体输入的字符串可以在这里查询[[虚拟轴字符串.png]]
```

---

## 其他

```csharp
//键盘鼠标 都是返回bool值
Input.anyKey // 是否有任意键/鼠标键持续按下
Input.anyKeyDown // 是否有任意键/鼠标键按下瞬间
Input.inputString // 当前帧键盘输入

// 手柄
Input.GetJoystickNames(); // 获取手柄名称列表 返回string数组
Input.GetButtonDown("按钮名字"); // 手柄按键按下
Input.GetButtonUp("按钮名字"); //手柄按键抬起
Input.GetButton("按钮名字");//手柄按键长按

//移动设备
if (Input.touchCount > 0)//如果触点大于0
{
    Touch t1 = Input.touches[0];//第一根手指输入内容
    t1.position //触摸位置
    t1.deltaPosition //触摸移动量
    t1.phase触摸阶段 //（Began/Moved/Ended 等）
}
Input.multiTouchEnabled = true;  // 开启多点触控

//陀螺仪
Input.gyro.enabled = true; // 开启陀螺仪
Input.gyro.gravity // 重力加速度向量
Input.gyro.rotationRate // 旋转速率
Input.gyro.attitude // 设备姿态（四元数）物体跟着手机一起动
```

---

## 练习

> 1. 使用之前的坦克预设体，用 WASD 键控制坦克的前进后退、左右转向

```csharp
public class Move_TK : MonoBehaviour
{
    public int moveSpeed   = 10;
    public int rotateSpeed = 50;

    void Update()
    {
        transform.Translate(Vector3.forward * moveSpeed *
            Input.GetAxis("Vertical") * Time.deltaTime);
        transform.Rotate(Vector3.up * rotateSpeed *
            Input.GetAxis("Horizontal") * Time.deltaTime);
    }
}
```

> 2. 在上一题的基础上，鼠标左右移动控制炮台的转向

```csharp
public class Move_TK : MonoBehaviour
{
    public int headSpeed = 50;
    public Transform head;

    void Update()
    {
        head.Rotate(Vector3.up, headSpeed * Input.GetAxis("Mouse X") * Time.deltaTime);
    }
}
```

---

## 我的踩坑记录

- `GetAxis` 有缓动效果，移动更平滑；`GetAxisRaw` 无缓动，适合需要精确控制的场景
- 

---

*最后更新：*
