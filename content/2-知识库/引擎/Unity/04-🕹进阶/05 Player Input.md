# 05 Player Input

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

>PlayerInput是InputSystem提供的
>专门用于接受玩家输入来处理自定义逻辑的组件

**主要工作原理**
1. 配置输入文件（InputActions文件）
2. 通过PlayerInput关联配置文件，它会自动解析该配置文件
3. 关联对应的响应函数，处理对应逻辑

**好处：**
- 不需要自己进行相关输入的逻辑书写
- 通过配置文件即可配置想要监听的对应行为
- 让我们专注于输入事件触发后的逻辑处理

---

## 窗口参数

**使用配置文件**
选择任意对象（一般为一个玩家对象）
为其添加Player Input组件
拖曳编辑好的配置文件，或 点击 Create Actions... 新建一个配置文件（推荐）

![[Player Input 参数.png]]

---

## 行为执行模式

**关键参数：** `InputValue` 和 `InputAction.CallbackContext`

**InputValue**
- **value.isPressed** 是否按下
- **value.Get<>** 得到具体返回值

**InputAction.CallbackContext**
- ![[03 Input Action#^3c3a50]]

---

### Send Messages / Broadcast Messages

**触发逻辑**
在自定义脚本中
申明名为 "On+行为名" 的函数
没有参数 或者 参数类型为InputValue
将该自定义脚本挂载到PlayerInput依附的对象上
当触发对应输入时 会自动调用函数

**并且还有默认的3个和设备相关的函数可以调用**
1. **设备注册**(当控制器从设备丢失中恢复并再次运行时会触发)：OnDeviceRegained(PlayerInput input)
2. **设备丢失**（玩家失去了分配给它的设备之一，例如，当无线设备耗尽电池时）：OnDeviceLost(PlayerInput input)
3. **控制器切换**：OnControlsChanged(PlayerInput input)

**Broadcast Messages 基本和SendMessage规则一致**
唯一的区别是，自定义脚本不仅可以挂载在PlayerInput依附的对象上
还可以挂载在其子对象下

```csharp
public void OnMove(InputValue value)
{
    print("Move");
    print(value.Get<Vector2>());//得到值
}

public void OnLook(InputValue value)
{
    print("Look");
    print(value.Get<Vector2>());
}
public void OnFire(InputValue value)
{
    print("Fire");
    if(value.isPressed)//当前状态
    {
        print("按下");
    }
}

public void OnDeviceLost(PlayerInput input)
{
    print("设备丢失");
}

public void OnDeviceRegained(PlayerInput input)
{
    print("设备注册");
}

public void OnControlsChanged(PlayerInput input)
{
    print("控制器切换");
}
```

---

### Invoke Unity Events

该模式可以在Inspector窗口上通过拖拽的形式关联响应函数

**注意：响应函数的参数类型 需要改为 InputAction.CallbackContext**

```csharp
//手动在PlayerInput拖拽关联即可
public void MyFire(InputAction.CallbackContext context)
{
    print("开火1");
}

public void MyMove(InputAction.CallbackContext context)
{
    print("移动1");
}

public void MyLook(InputAction.CallbackContext context)
{
    print("Look1");
}
```

---

### Invoke C Sharp Events

该模式通过C#事件监听处理对应逻辑，通过获取Playerlnput进行事件监听

```csharp
//1.获取PlayerInput组件
PlayerInput input = this.GetComponent<PlayerInput>();
//2.获取对应事件进行委托函数添加
input.onDeviceLost += OnDeviceLost;
input.onDeviceRegained += OnDeviceRegained;
input.onControlsChanged += OnControlsChanged;
input.onActionTriggered += OnActionTrigger;//动作触发

input.currentActionMap["Move"].ReadValue<Vector2>();//得到Move对应的Action中的值

//3.当触发输入时会自动触发事件调用对应函数
public void OnActionTrigger(InputAction.CallbackContext context)
{
    switch (context.action.name)//Action的名字
    {
        case "Fire":
            if(context.phase == InputActionPhase.Performed)
	            //输入阶段的判断 触发阶段 才去做逻辑
                print("开火");
            break;
        case "Look":
            print("看向");
            print(context.ReadValue<Vector2>());
            break;
        case "Move":
            print("移动");
            print(context.ReadValue<Vector2>());
            break;
    }
}
public void OnDeviceLost(PlayerInput input)
{
    print("设备丢失");
}

public void OnDeviceRegained(PlayerInput input)
{
    print("设备注册");
}

public void OnControlsChanged(PlayerInput input)
{
    print("控制器切换");
}
```

---

### 总结

| 区别项    | Send Messages                      | Broadcast Messages              | Invoke Unity Events                              | Invoke C Sharp Events                            |
| ------ | ---------------------------------- | ------------------------------- | ------------------------------------------------ | ------------------------------------------------ |
| 执行模式   | 代码                                 | 代码                              | 拖曳                                               | 代码                                               |
| 事件函数名  | On+行为名                             | On+行为名                          | 自定义                                              | 自定义                                              |
| 事件传入参数 | InputValue<br>特殊行为 PlayerInput<br> | InputValue<br>特殊行为 ：PlayerInput | InputAction.CallbackContext<br>特殊行为 ：PlayerInput | InputAction.CallbackContext<br>特殊行为 ：PlayerInput |

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

> 1. 请使用上一道练习题制作的输入配置文件，用Playerlnput为一个对象处理移动、跳跃、开火的逻辑，分别用4种行为执行模式处理

```csharp title:Message
public class InputSystem_Behavior_Messages : MonoBehaviour
{
    private Rigidbody rb;
    private Vector3 dir;
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    void Update()
    {
        rb.AddForce(dir * 3);
        
    }
    public void OnMove(InputValue value) 
    {
        dir = value.Get<Vector2>();
        dir.z = dir.y;
        dir.y = 0;
    }
    public void OnJump(InputValue value) 
    {
        rb.AddForce(Vector3.up * 300);
    }
    public void OnFire(InputValue value)
    {
        RaycastHit hit;
        Vector3 point;
        if (Physics.Raycast(Camera.main.ScreenPointToRay(Mouse.current.position.ReadValue()), out hit))
        {
            point = hit.point;
            point.y = transform.position.y;
            Instantiate(Resources.Load<GameObject>("Bullet"), transform.position,Quaternion.LookRotation(point - transform.position));
        }
    }
    public void OnDeviceLost(PlayerInput input) {  }
    public void OnDeviceRegained(PlayerInput input) {  }
    public void OnDControlsChanged(PlayerInput input) {  }
}
```

```csharp title:UnityEvent
public class InputSystem_Behavior_Unity : MonoBehaviour
{
    private Rigidbody rb;
    private Vector3 dir;
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    void Update()
    {
        rb.AddForce(dir * 3);
    }
    public void OnMove(InputAction.CallbackContext context) 
    {
        dir = context.ReadValue<Vector2>();
        dir.z = dir.y;
        dir.y = 0;
    }
    public void OnJump(InputAction.CallbackContext context) 
    {
        if (context.phase == InputActionPhase.Performed)
            rb.AddForce(Vector3.up * 300);
    }
    public void OnFire(InputAction.CallbackContext context)
    {
        if (context.phase == InputActionPhase.Performed)
        {
            RaycastHit hit;
            Vector3 point;
            if (Physics.Raycast(Camera.main.ScreenPointToRay(Mouse.current.position.ReadValue()), out hit))
            {
                point = hit.point;
                point.y = transform.position.y;
                Instantiate(Resources.Load<GameObject>("Bullet"), transform.position, Quaternion.LookRotation(point - transform.position));
            }
        }
    }
	public void OnDeviceLost(PlayerInput input) {  }
    public void OnDeviceRegained(PlayerInput input) {  }
    public void OnDControlsChanged(PlayerInput input) {  }
}
```

```csharp title:CSharpEvent
public class InputSystem_Behavior_CSharp : MonoBehaviour
{
    private Rigidbody rb;
    private Vector3 dir;
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        PlayerInput input = GetComponent<PlayerInput>();
        input.onDeviceLost += OnDeviceLost;
        input.onDeviceRegained += OnDeviceRegained;
        input.onControlsChanged += OnDControlsChanged;
        input.onActionTriggered += (context) => 
        {
            if (context.phase != InputActionPhase.Performed)
                return;
            switch (context.action.name)
            {
                case "Move":
                    dir = context.ReadValue<Vector2>();
                    dir.z = dir.y;
                    dir.y = 0;
                    break;
                case "Jump":
                    rb.AddForce(Vector3.up * 300);
                    break;
                case "Fire":
                    RaycastHit hit;
                    Vector3 point;
                    if (Physics.Raycast(Camera.main.ScreenPointToRay(Mouse.current.position.ReadValue()), out hit))
                    {
                        point = hit.point;
                        point.y = transform.position.y;
                        Instantiate(Resources.Load<GameObject>("Bullet"), transform.position, Quaternion.LookRotation(point - transform.position));
                    }
                    break;
            }
        };
    }
    void Update()
    {
        rb.AddForce(dir * 3);
    }
	public void OnDeviceLost(PlayerInput input) {  }
    public void OnDeviceRegained(PlayerInput input) {  }
    public void OnDControlsChanged(PlayerInput input) {  }
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
