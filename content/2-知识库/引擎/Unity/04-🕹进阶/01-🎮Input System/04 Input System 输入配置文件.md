# 04 Input System 输入配置文件

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 配置文件

**输入系统中提供了一种输入配置文件**
可以理解为是InputAction的集合
可以在一个文件中编辑多个InputAction的信息

**里面记录了想要处理的行为和动作（也就是InputAction的相关信息）**
可以在其中自己定义 InputAction（比如：开火、移动、旋转等）
然后为这个InputAction关联对应的输入动作

**之后将该配置文件和PlayerInput进行关联**
PlayerInput会自动帮助我们解析该文件
当触发这些InputAction输入动作时会以分发事件的形式通知我们执行行为

**创建配置文件**
1. 在Project窗口右键Create创建InputActions配置文件
2. 双击创建出的文件
3. 进行配置

---

### 窗口参数

![[Input System 配置文件.png]]

---

### 练习

> 1. 请配置一个玩家鼠标键盘输入配置玩家有移动、跳跃、开火等行为

![[Input System 配置文件 练习.png]]

---

## 生成和使用配置文件

**生成配置文件**
1. 选择InputActions文件
2. 在Inspector窗口设置生成路径，类名，命名空间
3. 应用后生成代码
![[Input System 生成配置文件类.png]]

**使用C#代码进行监听**

```csharp
配置文件类名 input;
void Start()
{
    //1.创建生成的代码对象
    input = new Lesson9Input();
    //2.激活输入
    input.Enable();
    //3.事件监听
    input.Action1.Fire.performed += (context) =>
    {
        print("开火");
    };

    input.Action2.Space.performed += (context) =>
    {
        print("跳跃");
    };
}
void Update()
{
    print(input.Action1.Move.ReadValue<Vector2>());
}
```

---

### 练习

> 1. 请使用上一道练习题制作的输入配置文件，为一个物体处理移动、旋转、跳跃、开火的逻辑

```csharp
public class InputActions_Test : MonoBehaviour
{
    private InputActions input;
    private Vector3 dir;
    private Rigidbody rb;
    void Start()
    {
        input = new InputActions();
        input.Enable();//区别 这里只用激活一次
        rb = GetComponent<Rigidbody>();
        input.Action1.Jump.performed += (context) => 
        {
            rb.AddForce(Vector3.up * 300);
        };
        input.Action1.Fire.performed += (context) => 
        {
            RaycastHit hit;
            Vector3 pos;
            if (Physics.Raycast(Camera.main.ScreenPointToRay(Mouse.current.position.ReadValue()), out hit))
            {
                pos = hit.point;
                pos.y = transform.position.y;
                Vector3 dir = pos - transform.position;
                Instantiate(Resources.Load("Bullet"), transform.position, Quaternion.LookRotation(dir));
            }
        };
    }
    void Update()
    {
        dir = input.Action1.Move.ReadValue<Vector2>();
        dir.z = dir.y;
        dir.y = 0;
        rb.AddForce(dir * 3);
    }
}
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

## 优先级 / 执行顺序

> 如果涉及优先级、执行顺序、作用域等，在这里说明

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
