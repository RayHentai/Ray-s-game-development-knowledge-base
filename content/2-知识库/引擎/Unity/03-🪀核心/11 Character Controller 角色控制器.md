# 11 Character Controller 角色控制器

**所属模块**：[[00 Unity 核心阶段总览]]
**关联**：[[20 刚体 Rigidbody]] | [[14 Transform 位移旋转缩放]]
**查阅次数**：0

---

## 核心理解

> 角色控制器是让角色可以受制于碰撞，但是不会被刚体所牵制

**如果我们对角色使用刚体判断碰撞，可能会出现一些奇怪的表现，比如：**
1. 在斜坡上往下滑动
2. 不加约束的情况碰撞可能让自己被撞飞
3. 等等

**而角色控制器会让角色表现的更加稳定，Unity提供了角色控制器脚本专门用于控制角色**

**注意：**
- 添加角色控制器后，不用再添加刚体
- 能检测碰撞函数
- 能检测触发器函数
- 能被射线检测
- 使用角色控制器尽量不要使用动画自带的位移

**存在碰撞器生命周期函数**
- OnControllerColliderHit 自身碰撞到其他对象
- OnCollisionEnter 被其他对象碰撞到 对角色控制器没用
- OnTriggerEnter  被其他触发器碰撞到

---

## 窗口参数
![[Character Controller.png]]

---

## 代码

```csharp
private CharacterController cc;
cc = GetComponent<CharacterController>();
//1 是否接触了地面
if (cc.IsGrounded)
//2 受重力作用的移动
cc.SimpleMove(Vector3.forward * 10 * Time.deltaTime);
//3 不受重力作用的移动
cc.Move(Vector3.forward * 10 * Time.deltaTime);
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

> 1. 在之前的练习题基础上，加入角色控制器控制角色的移动

```csharp
public class CharacterController_Move : MonoBehaviour
{
    private CharacterController cc;
    private Animator animator;
    private void Start()
    {
        cc = GetComponent<CharacterController>();
        animator = GetComponent<Animator>();
    }
    void Update()
    {
        animator.SetInteger("Speed", (int)Input.GetAxisRaw("Vertical"));
        cc.SimpleMove(transform.forward * 800 * Input.GetAxis("Vertical") * Time.deltaTime);
        transform.Rotate(Vector3.up * 80 * Input.GetAxis("Horizontal") * Time.deltaTime);
    }
}
```

---

## API 速查

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
