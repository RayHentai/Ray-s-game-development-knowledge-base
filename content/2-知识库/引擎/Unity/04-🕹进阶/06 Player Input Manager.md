# 06 Player Input Manager

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

**PlayerInputManager 组件主要是用于管理本地多人输入的输入管理器**
它主要管理玩家加入和离开

---

## 窗口参数

![[Player Input Manager 参数.png]]

---

## 使用

**注意：Player Prefab 中关联的预设体一定要有Player Input 脚本 不然会报错**
配置好面板参数之后，按指定的按键就可以创建玩家

```csharp
//以C Sharp Event模式为例
private Vector3 dir;
//获取PlayerInputManager
//PlayerInputManager.instance
//玩家加入时
PlayerInputManager.instance.onPlayerJoined += (playerInput) =>
{
    print("创建了一个玩家");
};
//玩家离开时
PlayerInputManager.instance.onPlayerLeft += (playerInput) =>
{
    print("离开了一个玩家");
};
void Update()
{
    this.transform.Translate(dir * 10 * Time.deltaTime);
}

public void Move(InputAction.CallbackContext context)
{
    dir = context.ReadValue<Vector2>();
    dir.z = dir.y;
    dir.y = 0;
}
```

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

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
