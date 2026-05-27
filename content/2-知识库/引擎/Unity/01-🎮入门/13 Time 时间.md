# ⏱️ 13 Time 时间

**所属模块**：[[00 Unity入门阶段总览]]
**关联**：[[09 脚本生命周期]] | [[14 Transform 位移旋转缩放]] | [[10 日期和时间]]
**查阅次数**：0

---

## 时间缩放

```csharp
Time.timeScale = 0;  // 时间暂停（暂停游戏）
Time.timeScale = 1;  // 时间正常
Time.timeScale = 2;  // 时间加速（2倍速）
```

---

## 帧间隔时间（最常用）

```csharp
Time.deltaTime // 上一帧到这一帧的时间间隔（受 timeScale 影响）
Time.unscaledDeltaTime // 不受 timeScale 影响的帧间隔时间
```

> **Time.deltaTime 是做帧率无关移动的关键：**
> `position += speed * Time.deltaTime` 让移动速度与帧率无关。

---

## 游戏时间

```csharp
Time.time // 游戏开始到现在的时间（受 timeScale 影响）
Time.unscaledTime // 游戏开始到现在的时间（不受 timeScale 影响）
```

---

## 物理帧时间（FixedUpdate）

```csharp
Time.fixedDeltaTime // 物理帧间隔时间（在 Project Settings → Time 中设置）
Time.fixedUnscaledDeltaTime // 不受 timeScale 影响的物理帧间隔
```

---

## 帧计数

```csharp
Time.frameCount // 游戏到目前为止跑了多少帧
```

---

## 练习

> 1. 在哪里可以设置物理更新的间隔时间？

```csharp
Edit → Project Settings → Time → Fixed Timestep（固定时间步长）
//[[练习12 物理帧间隔时间设置入口.png]]
```

> 2. 请问 Time 中的各个时间变量对于我们来说可以用来做什么？

```
① Time.timeScale：时间暂停、倍速、恢复正常（暂停游戏/慢动作）
② Time.deltaTime：帧间隔时间，用于计算帧率无关的位移
③ Time.frameCount：游戏跑了多少帧，可以用来做帧计数逻辑
```

---

## 我的踩坑记录

- 移动和旋转一定要乘以 `Time.deltaTime`，否则在不同帧率的设备上表现不一致

---

*最后更新：*
