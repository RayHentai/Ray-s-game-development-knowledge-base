# 🎲 23 Random 随机数

**所属模块**：[[00 Unity入门阶段总览]]
**关联**：[[15 随机数]]
**查阅次数**：0

---

## 核心理解

> **Unity 中的 Random 类不是 C# 中的 Random 类！**
> Unity 的 Random 在 `UnityEngine` 命名空间中，C# 的 Random 在 `System` 命名空间中。

---

## Unity Random

```csharp
// 整数随机（包含最小值，不包含最大值）
int i = Random.Range(0, 100);    // 0~99

// 浮点数随机（包含两端）
float f = Random.Range(1.1f, 100.1f);

// 随机单位向量（随机方向）
Vector3 dir = Random.insideUnitSphere;

// 随机单位球面上的点
Vector3 point = Random.onUnitSphere;
```

---

## C# System.Random

```csharp
// 需要先 new 对象（或使用 Unity Random 代替）
System.Random r = new System.Random();
int i = r.Next(0, 100);
```

---

## 我的踩坑记录

- Unity 的 `Random.Range(0, 100)` 整数上限不包含，浮点数上限包含，注意区别

---

*最后更新：*
