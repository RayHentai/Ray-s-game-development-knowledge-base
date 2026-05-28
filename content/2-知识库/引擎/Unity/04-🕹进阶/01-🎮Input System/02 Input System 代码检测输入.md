# 02 Input System 代码检测输入

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 键盘输入

```csharp
//新输入系统 提供了对应的输入设备类 帮助我们对某一种设备输入进行检测
Keyboard keyBoard = Keyboard.current;//得到当前活跃的键盘

//首先要得到某一个按键 通过键盘类对象 点出 各种按键 来获取
//keyBoard.aKey
//空格键 当前帧 是否按下
if (Keyboard.current.spaceKey.wasPressedThisFrame)
{
    print("空格键按下");
}

//判断D键是否释放
if (Keyboard.current.dKey.wasReleasedThisFrame)
{
    print("D键抬起");
}

//判断空格是否一直处于按下状态
if (Keyboard.current.spaceKey.isPressed)
{
    print("空格按下状态");
}

//通过事件监听按键按下
//通过给keyboard对象中的 文本输入事件 添加委托函数
//便可以获得每次输入的内容
private void TextInput(char c)
{
    print("通过函数进行事件监听" + c);
}

keyBoard.onTextInput += (c) =>
{
    print("通过lambda表达式" + c);
};

keyBoard.onTextInput += TextInput;
keyBoard.onTextInput -= TextInput;

//任意键按下监听
//可以处理 任意键 按下 抬起 长按 相关的逻辑

//任意键按下了
if(Keyboard.current.anyKey.wasPressedThisFrame)
{
    print("任意键按下");
}
```

---

### 练习

> 1. 利用目前所学知识，用新输入系统的鼠标键盘输入制作一个这样的功能
> 场景上有一个3D立方体，按键盘上的+和-可以对其进行缩放缩放系数默认为1，最小为1
> 每按一次+，缩放系数+1；每按一次-，缩放系数-1

```csharp
public class KeyCode_Input : MonoBehaviour
{
    public Transform cubeTrans;
    private int scaleFactor = 1;
    void Update()
    {
        if (Keyboard.current.numpadPlusKey.wasPressedThisFrame || Keyboard.current.equalsKey.wasPressedThisFrame) 
        {
            scaleFactor += 1;
            cubeTrans.localScale = Vector3.one * scaleFactor;
        }
        if (Keyboard.current.numpadMinusKey.wasPressedThisFrame || Keyboard.current.minusKey.wasPressedThisFrame)
        {
            scaleFactor -= 1;
            if (scaleFactor < 1)
                scaleFactor = 1;
            cubeTrans.localScale = Vector3.one * scaleFactor;
        }
    }
}
```

---

## 鼠标输入

```csharp
//获取当前鼠标设备（需要引用命名空间）
Mouse mouse = Mouse.current;

//鼠标左键
mouse.leftButton
//鼠标右键
mouse.rightButton
//鼠标中键
mouse.middleButton
//鼠标 向前向后键
mouse.forwardButton
mouse.backButton

//鼠标各键位 按下 抬起 长按
//按下
if (Mouse.current.leftButton.wasPressedThisFrame)
{
    print("鼠标左键按下");
}
//抬起
if (Mouse.current.leftButton.wasReleasedThisFrame)
{
    print("鼠标左键抬起");
}
//长按
if (Mouse.current.rightButton.isPressed)
{
    print("鼠标右键长按");
}

鼠标位置相关
//获取当前鼠标位置
mouse.position.ReadValue();
print(Mouse.current.position.ReadValue());//屏幕坐标
//得到鼠标两帧之间的一个偏移向量 
mouse.delta.ReadValue();
print(Mouse.current.delta.ReadValue());//帧偏移值
//鼠标中键 滚轮的方向向量
mouse.scroll.ReadValue();
print(Mouse.current.scroll.ReadValue());//
```

### 练习

> 1. 利用目前所学知识，用新输入系统的鼠标键盘输入制作一个这样的功能
> 场景上有一个3D立方体，当鼠标点击选中它时，它的颜色变为红色
> 并且按键盘上的+和-可以对其进行缩欣
> 缩放系数默认为1，最小为1每按+一次，缩放系数+1每按-一次，缩放系数-1

```csharp
public class Mouse_Input : MonoBehaviour
{
    private GameObject cube;
    public Material red;
    private Material normal;
    private int scaleFactor = 1;
    void Update()
    {
        if (Mouse.current.leftButton.wasPressedThisFrame)
        {
            RaycastHit hits;
            if (Physics.Raycast(Camera.main.ScreenPointToRay(Mouse.current.position.ReadValue()), out hits))
            {
                cube = hits.collider.gameObject;
                normal = cube.GetComponent<MeshRenderer>().material;
                cube.GetComponent<MeshRenderer>().material = red;//换材质球
            }
            else 
            {
                if (cube != null)//还原材质球
                    cube.GetComponent<MeshRenderer>().material = normal;
                normal = null;
                cube = null;
            }
        }
        if (cube != null)
        {
            if(Keyboard.current.numpadPlusKey.wasPressedThisFrame || Keyboard.current.equalsKey.wasPressedThisFrame)
        {
                scaleFactor += 1;
                cube.transform.localScale = Vector3.one * scaleFactor;
            }
            if (Keyboard.current.numpadMinusKey.wasPressedThisFrame || Keyboard.current.minusKey.wasPressedThisFrame)
            {
                scaleFactor -= 1;
                if (scaleFactor < 1)
                    scaleFactor = 1;
                cube.transform.localScale = Vector3.one * scaleFactor;
            }
        }
    }
}
```

---

## 触屏输入

```csharp
//获取当前触屏设备
Touchscreen ts = Touchscreen.current;
//由于触屏相关都是在移动平台或提供触屏的设备上使用
//所以在使用时最好做一次判空
if (ts == null)
    return;

print(ts.touches.Count);//得到触屏手指数量
ts.touches[1] //得到单个触屏手指
foreach (var item in ts.touches) {  } //得到所有触屏手指

//获取指定索引手指
TouchControl tc = ts.touches[0];
if(tc.press.wasPressedThisFrame) {  } //按下 
if(tc.press.wasReleasedThisFrame) {  } //抬起
if(tc.press.isPressed) {  } //长按
if(tc.tap.isPressed) {  } //点击手势
print(tc.tapCount); //连续点击次数

//手指位置等相关信息
print(tc.position.ReadValue());//位置
print(tc.startPosition.ReadValue());//第一次接触时位置
tc.radius.ReadValue();//接触区域大小
tc.delta.ReadValue();//偏移位置

//得到当前手指的 状态（阶段）
UnityEngine.InputSystem.TouchPhase tp = tc.phase.ReadValue();
switch (tp)
{
    //无
    case UnityEngine.InputSystem.TouchPhase.None:
        break;
    //开始接触
    case UnityEngine.InputSystem.TouchPhase.Began:
        break;
    //移动
    case UnityEngine.InputSystem.TouchPhase.Moved:
        break;
    //结束
    case UnityEngine.InputSystem.TouchPhase.Ended:
        break;
    //取消
    case UnityEngine.InputSystem.TouchPhase.Canceled:
        break;
    //静止
    case UnityEngine.InputSystem.TouchPhase.Stationary:
        break;
    default:
        break;
}
```

---

## 手柄输入

```csharp
//获取当前手柄
Gamepad gamePad = Gamepad.current;
if (gamePad == null)
    return;

//手柄摇杆
//摇杆方向 右摇上摇正数 左摇下摇负数 范围-1 ~ 1 
//左摇杆
print(gamePad.leftStick.ReadValue());
//右摇杆
print(gamePad.rightStick.ReadValue());

//摇杆按下
//右摇杆 按下抬起长按相关
gamePad.rightStickButton
//左摇杆
if (Gamepad.current.leftStickButton.wasPressedThisFrame)
{
    print("左摇杆按下");
}
if (Gamepad.current.leftStickButton.wasReleasedThisFrame)
{
    print("左摇杆抬起");
}
if (Gamepad.current.leftStickButton.isPressed)
{
    print("左摇杆长按");
}

//手柄方向键
//对应手柄上4个方向键 上下左右
gamePad.dpad.left
gamePad.dpad.right
gamePad.dpad.up
gamePad.dpad.down

if (Gamepad.current.dpad.left.wasPressedThisFrame)
{
    print("左方向键按下");
}
if (Gamepad.current.dpad.left.wasReleasedThisFrame)
{
    print("左方向键抬起");
}
if (Gamepad.current.dpad.left.isPressed)
{
    print("左方向键长按");
}

//手柄右侧按键
//通用
//Y、△
gamePad.buttonNorth
//A、X
gamePad.buttonSouth
//X、□
gamePad.buttonWest
//B、○
gamePad.buttonEast

//手柄右侧按钮 x ○ △ □ A B Y 
//○
gamePad.circleButton
//△
gamePad.triangleButton
//□
gamePad.squareButton
//X
gamePad.crossButton
//x
gamePad.xButton
//a
gamePad.aButton
//b
gamePad.bButton
//Y
gamePad.yButton

//输入检测
wasPressedThisFrame
wasReleasedThisFrame
isPressed

if(Gamepad.current.buttonNorth.wasPressedThisFrame)
{
    print("上方按键 三角形键(PS)按下");
}

//手柄中央按键
//中央键
gamePad.startButton
gamePad.selectButton

//输入检测
wasPressedThisFrame
wasReleasedThisFrame
isPressed

if(Gamepad.current.startButton.wasPressedThisFrame)
{
    print("开始键按下");
}
if (Gamepad.current.selectButton.wasPressedThisFrame)
{
    print("选择键按下");
}

//手柄肩键
//左上右上 肩部键位
//左右前方肩部键
gamePad.leftShoulder
gamePad.rightShoulder

//左右后方触发键
gamePad.leftTrigger
gamePad.rightTrigger

//输入检测
wasPressedThisFrame
wasReleasedThisFrame
isPressed

if(Gamepad.current.leftShoulder.wasPressedThisFrame)
{
    print("左侧肩部前方键");
}
if (Gamepad.current.leftTrigger.wasPressedThisFrame)
{
    print("左侧肩部后方键");
}
```

---

## 其他输入

**新输入系统中的输入设备类**
**常用的**
- Keyboard—键盘
- Mouse—鼠标
- Touchscreen—触屏
- Gamepad—手柄

**其它**
- Joystick—摇杆
- Pen—电子笔
- Sensor（传感器）
	https://docs.unity3d.com/Packages/com.unity.inputsystem@1.2/manual/Sensors.html#accelerometer
- Gyroscope—陀螺仪
- GravitySensor—重力传感器
- 加速传感器
- 光照传感器
- 等等

其他没有细讲的设备
平时在开发中不是特别常用
如果想要学习他们的使用
最直接的方式就是看官方的文档
或者直接进到类的内部查看具体成员
通过查看变量名和方法名即可了解使用方式

```csharp
//新老输入系统 Input类可能会重名，可以用命名空间点出来用
UnityEngine.InputSystem.Gyroscope g = UnityEngine.InputSystem.Gyroscope.current;//陀螺仪
g.angularVelocity.ReadValue()
```

**注意:**
- 新输入系统的设计初衷就是想提升开发者的开发效率，不提倡写代码来处理输入逻辑
- 之后学了配置文件相关知识后，都是通过配置文件来设置监听（监视窃听）的输入事件类型
- 只需要把工作重心放在输入触发后的逻辑处理
- 所以我们目前讲解的知识都是为了之后做准备，实际开发中使用较少

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

---

## API速查


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
