# 03 Input Action

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

**InputAction 是 InputSystem帮助我们封装的输入动作类**

作用是不需要我们通过写代码的形式来处理输入
而是直接在Inspector窗口编辑想要处理的输入类型

当输入触发时，我们只需要把精力花在输入触发后的逻辑处理上

在想要用于处理输入动作的类中，申明对应的InputAction类型的成员变量

**注意：需要引用命名空间UnityEngine.InputSystem**

---

## Input System Package设置

**设置入口**
任意触发相关参数下 Open Input Settings -> 点击Create settings asset -> 生成一个配置文件就可以修改了 

**参数相关**
![[Input System Package设置.png]]

---

## 窗口参数

---

### 齿轮

---

#### Action

![[Action 动作输入设置.png]]

---

#### Interactions

>相互作用设置，用于特殊输入，比如长按、多次点击等等
>当满足条件时才会触发这个行为(设置长按时间、点击次数等等）

**三个事件：**
开始started 立刻执行
触发performed 满足条件后执行
结束canceled 没有满足条件提前结束执行

**Hold**
适用于需要输入设备保持一段时间的操作。
当按钮按下会触发started，若在松开按钮前，按住时间大于等于Hold Time则会触发performed（时间一到就触发），否则触发canceled。

**Tap**
和Hold相反，需要在一段时间内按下松开来触发。
当按钮按下会触发started，若在MaxTapDuriation时间内（小于）松开按钮，触发performed，否则触发canceled。

**SlowTap**
类似Hold，但是它在按住时间大于等于Max Tap Duriation的时候，并不会立刻触发performed，而是会在松开的时候才触发performed。

**MultiTap**
用作于多次点击，例如双击或者三连击。
TapCount 为点击次数
MaxTapSpacing 为每次点击之间的间隔（默认值为2 * MaxTapDuration）。
Max TapDuration 为每次点击的持续时间，即按下和松开按钮的这段时间。
当每次点击时间小于 MaxTapDuration，且点击间隔时间小于 MaxTap Spacing，点击 TapCount次，触发performed。

**Press**
可以实现类似按钮的操作
- **PressOnly：** 按下的时候触发started和performed，不触发canceled
- **ReleaseOnly：** 按下的时候触发started，松开的时候触发performed
- **Press And Release：** 按下的时候触发started和performed，松开的时候会再次触发started和performed。不触发canceled

**PressPoint：** 在InputSystem中，每个按钮都有对应的浮点值，例如普通的按钮，将会在0（未按下）和1（按下）之间。
因此我们可以利用这个值（PressPoint）来进行区分，当大于等于这个值则认为按钮按下了。

---

#### Processors

>值处理加工设置，对得到的值进行处理加工

**Clamp**
将输入值钳制到`[min.max]`范围。

**Invert**
反转控件中的值（即，将值乘以-1）。

**Invert Vector 2**
反转控件中的值（即，将值乘以-1）。如果invertX为真，则反转矢量的x轴；如果invertY为真，则反转矢量的y轴。

**Invert Vector 3**
反转控件中的值（即，将值乘以-1）。如果反转x为真，则反转矢量的x轴；如果反转y为真，则反转y轴；如果反转z为真，则反转z轴。

**Normalize**
如果最小值>=零，则将`[min..max]`范围内的输入值规格化为无符号规格化形式`[0..1]`，如果最小值<零，则将输入值规格化为有符号规格化形式`[-1..1]`。

**Normalize Vector 2**
将输入向量规格化为单位长度（1）。

**Normalize Vector 3**
将输入向量规格化为单位长度(1)

**Scale**
将所有输入值乘以系数。

**Scale Vector 2**
将所有输入值沿x轴乘以x，沿y轴乘以y。

**Scale Vector 3**
将所有输入值沿x轴乘以x，沿y轴乘以y，沿z轴乘以z。

**Axis Deadzone**
axis死区处理器缩放控件的值，使绝对值小于最小值的任何值为0，绝对值大于最大值的任何值为1或-1。
许多控件没有精确的静止点（也就是说，当控件位于中心时，它们并不总是精确报告0）。
在死区处理器上使用最小值可避免此类控件的无意输入。
此外，当轴一直移动时，某些控件不一致地报告其最大值。
在死区处理器上使用最大值可确保在这种情况下始终获得最大值。

**Stick Deadzone**
摇杆死区处理器缩放Vector2控件（如摇杆）的值，以便任何幅值小于最小值的输入向量都将得到（0,0），而任何幅值大于最大值的输入向量都将规格化为长度1。
许多控件没有精确的静止点（也就是说，当控件位于中心时，它们并不总是精确地报告0，0）。
在死区处理器上使用最小值可避免此类控件的无意输入。
此外，当轴一直移动时，某些控件不一致地报告其最大值。
在死区处理器上使用最大值可确保在这种情况下始终获得最大值。

---

### 加号

![[Input Action 加号参数.png|365]]

**Path**
![[Input Action Path.png]]

**1D Axis**
![[Input Action 1D Axis.png|386]]

**2D Vector**
![[Input Action 2D Vector.png]]

**Btn One**
![[Input Action BtnOne.png]]

---

# CallbackContext

```csharp
move.performed += (context) =>
{
    //CallbackContext
    //当前状态 phase 是一个枚举
    //没有启用 Disabled
    //等待 Waiting
    //开始 Started
    //触发 Performed
    //结束 Canceled
    //context.phase 状态
    print(context.phase);//打印状态
    print(context.action.name);//动作行为信息 
    print(context.control.name);//控件(设备)信息
    context.ReadValue<float>//获取值
    print(context.duration);//持续时间
    print(context.startTime);//开始时间
};
```

^3c3a50


---

## 使用

```csharp
[Header("Binding")]// 特性 显示分组描述文字
public InputAction move;
[Header("1D Axis")]
public InputAction axis;
[Header("2D Vector")]
public InputAction vector2D;
[Header("3D Vector")]
public InputAction vector3D;

[Header("Button With One")]
public InputAction btnOne;

//1.启用输入检测
move.Enable();

//2.操作监听相关
private void TestFun(InputAction.CallbackContext context)
{
    print("开始事件调用");
}
//开始操作
move.started += TestFun;
//真正触发
move.performed += (context) =>
{
    print("触发事件调用");
    //CallbackContext
    //当前状态 是一个枚举
    //没有启用 Disabled
    //等待 Waiting
    //开始 Started
    //触发 Performed
    //结束 Canceled
    //context.phase 状态
    print(context.phase);//打印状态
    
    print(context.action.name);//动作行为信息 
    print(context.control.name);//控件(设备)信息
    context.ReadValue<float>//获取值
    print(context.duration);//持续时间
    print(context.startTime);//开始时间
};

//结束操作
move.canceled += (context) =>
{
    print("结束事件调用");
};

axis.Enable();
vector2D.Enable();
vector3D.Enable();

btnOne.Enable();
btnOne.performed += (context) =>
{
    print("组合键触发");
};
```

---

## 练习

> 1. 使用InputAction类为一个3D对象制作通过鼠标键盘控制其移动、跳跃、开火的逻辑(移动跳跃 利用物理系统刚体加力)

```csharp
public class InputAction_ : MonoBehaviour
{
    [Header("移动")]
    public InputAction move;
    [Header("跳跃")]// 特性 显示分组描述文字
    public InputAction jump;
    [Header("发射")]
    public InputAction fire;

    private Rigidbody rb;
    private Vector3 dir;

    void Start()
    {
        move.Enable();
        jump.Enable();
        fire.Enable();
        rb = GetComponent<Rigidbody>();
        jump.performed += (context) =>
        {
            rb.AddForce(Vector3.up * 300);
        };
        fire.performed += (context) =>
        {
            Vector3 point;
            Physics.Raycast(Camera.main.ScreenPointToRay(Mouse.current.position.ReadValue()), out RaycastHit hits);
            point = hits.point;
            point.y = transform.position.y;//让接触点的y与发射者持平 不写这一行代码 子弹是歪的 会很奇怪 
            Vector3 dir = point - transform.position;
            Instantiate(Resources.Load<GameObject>("Bullet"), transform.position, Quaternion.LookRotation(dir));
        };
    }

    void Update()
    {
        dir = move.ReadValue<Vector2>();
        dir.z = dir.y;
        dir.y = 0;
        rb.AddForce(dir * 3);
    }
}
```

---

# API速查


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
