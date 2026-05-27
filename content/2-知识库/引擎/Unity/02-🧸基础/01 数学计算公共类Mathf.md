# 01 数学计算公共类Mathf

**所属模块**：[[00 Unity 基础阶段总览]]
**关联**：[[14 Transform 位移旋转缩放]] | [[02 三角函数]]
**查阅次数**：1

---

## Mathf 和 Math

**Math：** C#中封装好的用于数学计算的工具类，位于System命名空间中

**Mathf：** 是Unity中封装好的用于数学计算的工具结构体，位于UnityEngine命名空间中

---

## 区别

| 对比向 | Math     | Mathf                                       | 区别说明 |
| --- | -------- | ------------------------------------------- | ---- |
| 方法  | C#中提供的方法 | Unity中提供的方法<br>包含Math中的方法<br>多了一些适用于游戏开发的方法 | 几乎一样 |


---

## 常用方法

---

### 一次计算

```csharp
//π - PI
Mathf.PI //3.1415926

//绝对值 - Abs
Mathf.Abs(-10) // 10

//向上取整 - CeilToInt
float f = 1.3f;
Mathf.CeilToInt(f) // 2

//向下取整 - FloorToInt
float f = 1.3f;
Mathf.CeilToInt(f) // 1 等同(int)f;

//钳制函数 - Clamp
// 比小的还小 就取最小 比大的还大 就取最大 两者之间就取本身
Mathf.Clamp(10, 11, 20) // 11
Mathf.Clamp(21, 11, 20) // 20
Mathf.Clamp(15, 11, 20) // 15

//获取最大值 - Max
Mathf.Max(1, 2, 3, 4, 5, 6, 7, 8) // 8

//获取最小值 - Min
Mathf.Min(1, 2, 3, 4, 5, 6, 7, 8) // 1

//一个数的n次幂 - Pow
Mathf.Pow(4, 2) // 16

//四舍五入 - RoundToint
Mathf.RoundToint(1.3f) //1
Mathf.RoundToint(1.5f) //2

//返回一个数的平方根 - Sqrt
Mathf.Sqrt(4) //2

//判断一个数是否是2的n次方 - IsPowerOfTwo
Mathf.IsPowerOfTwo(16) // true
Mathf.IsPowerOfTwo(3) // false

//判断正负数 - Sign
Mathf.Sign(0) // 1
Mathf.Sign(10) // 1
Mathf.Sign(-10) // -1
```

^8a75be

---

### 插值运算

```csharp
//插值运算 - Lerp

//Lerp函数公式
//result = Mathf.Lerp(start, end, t);

//t为插值系数 取值范围为0 ~ 1
//result = start + (end - Start) * t

//用法一 每帧改变start的值 —— 变化速度先快后慢，位置无限接近，但是不会得到end位置
//[[插值运算1.png]]
start = Mathf.Lerp(start, 10, Time.deltaTime);
// 0 + (10 - 0) * 0.02 = 0.2
// 0.02 + (10 - 0.02) * 0.02 =  0.3996
//...

//用法二 每帧改变t的值 一 变化速度匀速，位置每帧接近，当t >= 1时，得到结果
//[[插值运算2.png]]
time += Time.deltaTime;
float result = Mathf.Lerp(start, 10, Time);
```

^635a36

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- 数学计算
- 线性插值 ：跟随移动 -> 掉落物的吸引
- 钳制函数：返回一个在最大范围和最小范围之内的值

---

## 练习

> 1. 使用线性插值实现一个方块跟随另一个方块移动

```csharp
//先快后慢
public class Mathf_Follow : MonoBehaviour
{
    public Transform target;
    public float moveSpeed = 5;
    private Vector3 pos;
    
    void Update()
    {
        pos = transform.position;
        pos.x = Mathf.Lerp(pos.x, target.position.x, Time.deltaTime * moveSpeed);
        pos.y = Mathf.Lerp(pos.y, target.position.y, Time.deltaTime * moveSpeed);
        pos.z = Mathf.Lerp(pos.z, target.position.z, Time.deltaTime * moveSpeed);
        transform.position = pos;
    }
}

//匀速移动
public class Mathf_Beyond : MonoBehaviour
{
    public Transform target;
    private float time;
    private Vector3 pos;
    private Vector3 targetNowPos;
    private Vector3 startPos;
    
    void Update()
    {
        if (targetNowPos != target.position)
        {
            time = 0;
            startPos = transform.position;
            targetNowPos = target.position;
        }
        time += Time.deltaTime;
        pos.x = Mathf.Lerp(startPos.x, target.position.x, time);
        pos.y = Mathf.Lerp(startPos.y, target.position.y, time);
        pos.z = Mathf.Lerp(startPos.z, target.position.z, time);
        transform.position = pos;
    }
}
```

^34e3f8

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
