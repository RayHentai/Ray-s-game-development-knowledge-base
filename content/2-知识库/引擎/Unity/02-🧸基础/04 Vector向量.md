# 04 Vector向量

**所属模块**：[[00 Unity 基础阶段总览]]
**关联**：[[01 数学计算公共类Mathf]] | [[02 三角函数]] 
**查阅次数**：0

---

## 向量基础

---

### 向量的基本概念

**标量：** 有数值大小，没有方向
![[标量.png|134]]

**向量：**
- 有数值大小，有方向的矢量
- 一维、二维、三维...
- 注意：向量在空间中有无数条可以随意流动
![[向量.png|444]]

```csharp
//三维向量 - Vector3
//Vector3 有两种几何意义
//1 位置 - 代表一个点
transform.position

//2 方向 - 代表一个方向
transform.forward
```

### 两点决定一向量

>口诀 终点减起点

![[两点决定一向量.png|181]]

**A点：**(Xa, Ya, Za)
**B点：**(Xb, Yb, Zb)

**从A指向B的向量为AB向量**
B - A = (Xb - Xa, Yb - Ya, Zb - Za)

**从B指向A的向量为BA向量**
A - B = (Xa - Xb, Ya - Yb, Za - Zb)

```csharp
//A B 的几何意义是两个点
Vector3 A = new Vector3(1, 2, 3);
Vector3 B = new Vector3(5, 1, 5);

//AB BA的几何意义是两个向量
Vector3 AB = B - A;
Vector3 BA = A - B;
```

### 零向量和负向量

**零向量：**（0, 0, 0）

**负向量：**
- （x, y, z）的 负向量 为 （-x, -y, -z）
- 负向量和原向量的大小相等
- 负向量和原向量的方向相反

```csharp
//零向量
Vector3.zero

//负向量
-Vector3.forward
```

---

### 向量模长

> 模长即向量的长度，向量是由两个点算出，所以向量的模长就是两个点的距离

**模长公式：**
- A向量(x, y, z)
- 模长 = √x² + y² + z²


```csharp
//Vector3 中提供了向量模长的成员属性 magnitude
Vector3 A = new Vector3(1, 2, 3);
Vector3 B = new Vector3(5, 1, 5);
Vector3 AB = B - A;
AB.magnitude
Vector3.Distance(A, B);//这个方法也可以得到两点的长度 和 magnitude 有一定关联

//如果得到 代表一个点的 向量的模长
//这个模长就代表 这个点 到 坐标原点的距离
A.magnitude 
```

---

### 单位向量

>模长为1的向量为单位向量

- 任意一个向量经过归一化就是单位向量
- 只需要方向 不想让模长影响计算结果时使用单位向量

**归一化公式：**
- A向量(x, y, z)
- 模长 = √x² + y² + z²
- 单位向量 = （x / 模长, y / 模长, z / 模长）

```csharp
//Vector3 中提供了 获取单位向量的成员属性 normalized
Vector3 A = new Vector3(1, 2, 3);
Vector3 B = new Vector3(5, 1, 5);
Vector3 AB = B - A;
AB.normalized 
AB / AB.magnitude //和上面是一样的
```

---

### 练习

> 1. Unity中判断两点之间距离有几种方式？

```csharp
// 1 Vector3 提供的 Distance 方法
Vector3.Distance(A, B);
// 2 Vector3 提供的 magnitude 属性
(A - B).magnitude
(B - A).magnitude
```

> 2. 计算向量（3,4,5）的模长（手写)

```csharp
√ 3² + 4² + 5²
√ 9 + 16 + 25
√ 50
```

> 3. 计算向量 (3,-4）的单位向量(手写)

```csharp
(3, -4) 的 模长 = 
√ 3² + (-4)²
√ 9 + 16
√25
5

(3, -4)的 单位向量 = 
(3 / 5 , -4 / 5)
```

---
 
## 向量运算

---

### 四则运算

---
##### 加

**公式：**
- **向量A：**(Xa, Ya, Za)
- **向量B：**(Xb, Yb, Zb)
- A + B = (Xa + Xb, Ya + Yb , Za + Zb)

**Vector3 + Vector3 的几何意义：**

1. **位置 + 位置： 
- 没有任何意义

2. **向量 + 向量**
- 向量 + 向量 = 向量
- 两个向量相加得到一个新向量
- 口诀：向量相加 首尾相连
![[向量加向量.png|300]]

3. **位置 + 向量**
- 位置 + 向量 = 位置
- 向量 + 位置 = 位置
- 位置加向量得到一个新位置
- 口诀 ： 位置和向量相加 = 平移位置
![[位置加向量.png|326]]

---

##### 减

**公式：**
- **向量A：**(Xa, Ya, Za)
- **向量B：**(Xb, Yb, Zb)
- A - B = (Xa - Xb, Ya - Yb , Za - Zb)

**Vector3 - Vector3 的几何意义：**

1. **位置 - 位置： 
- 位置 - 位置 = 向量
- 得到一个新向量
- 口诀：两点决定一向量 终点 - 起点 
![[位置减位置.png|260]]

2. **向量 - 向量**
- 两个向量相减得到一个新向量
- 口诀：向量想减 头连头 尾连尾 A - B = B头指A头
![[向量减向量.png|295]]

3. **位置 - 向量**
- 位置 + (-向量) = 位置
- 位置减向量 相当于 加负向量
- 口诀 ： 位置减向量 = 平移位置
![[位置减向量.png|318]]

4. **向量 - 位置**
- 没有任何意义

---

##### 乘除

>向量只会和标量进行乘除法运算

**公式：**
- **向量A：**(x, y, z)
- **标量a**
- A * a = (x * a, y * a, z * a)
- A / a = (x / a, y / a, z / a)

**Vector3 ****or/ Vector3 的几何意义：**
1. 向量 * or / 标量 = 向量
2. 向量 * or / 正数 方向不变，放大缩小模长
3. 向量 * or / 负数 方向相反，放大缩小模长
4. 向量 * 0 得到零向量

---

### 点乘

#### 基础内容

**公式：**
- **向量A：**(Xa, Ya, Za)
- **向量B：**(Xb, Yb, Zb)
- 向量 · 向量 = 标量
- A · B = Xa * Xb + Ya * Yb + Za * Zb

**Vector3 · Vector3 的几何意义：**
- 点乘可以得到一个向量在自己向量上投影的长度
-  点乘结果>0两个向量夹角为锐角
-  点乘结果=0两个向量夹角为直角
-  点乘结果<0两个向量夹角为钝角
-  我们可以用这个规律判断敌方的大致方位 
	- AB(玩家—>敌人) · A(正朝向) 
	- > 0 在玩家的前方
	- = 0 在玩家的左右两端
	- < 0 在玩家的右端
![[向量点乘.png|230]]

#### 公式推导：两个向量的夹角

![[向量夹角公式推导.png|168]]

```csharp
∵ Cosβ = 直角边 / 单位向量B模长
直角边 = Cosβ * 单位向量B模长

又∵ 直角边 = 单位向量A · 单位向量B

∴ Cosβ * 单位向量B模长 = 单位向量A · 单位向量B 
Cosβ = 单位向量A · 单位向量B  / 单位向量B模长
Cosβ = 单位向量A · 单位向量B  / 1
Cosβ = 单位向量A · 单位向量B

∴ β = Acos(单位向量A · 单位向量B)
```

---

### 叉乘

**公式：**
- 向量 x 向量 = 新向量
- 向量A（Xa, Ya, Za）
- 向量B（Xb, Yb, Zb）
- A x B = (X, Y, Z)
- X = Ya · Zb - Za · Yb
- Y = Za · Xb - Xa · Zb
- Z = Xa · Yb - Ya · Xb
![[向量叉乘计算.png|267]]

**Vector3 x Vector3 的几何意义：**
- 叉乘得到的向量同时垂直与A 和 B 
- 叉乘得到的向量同时垂直与A 和 B 组成的平面
- 垂直于平面的向量被称作法向量
- A x B = -(B x A)
- 叉乘结果的的 y > 0 证明 B 在 A 右侧
- 叉乘结果的的 y < 0 证明 B 在 A 左侧

---

### 插值运算

#### 线性插值

```csharp
//[[01 数学计算公共类Mathf#^635a36]] | [[01 数学计算公共类Mathf#^34e3f8]]
//result = Mathf.Lerp(start, end, t);
Vector3.Lerp(start, end, t);
Transform A;
Transform terget;
// 1 先快后慢
A.position = Vector3.Lerp(A.position, terget.position, Time.deltaTime)
// 2匀速移动
float time;
Vector3 startPos;
Vector3 nowTergetPos;
if (nowTergetPos != terget.position)
{
	nowTergetPos = terget.position;
	time = 0;
	startPos = A.position
}
time += Time.deltaTime;
A.position = Vector3.Lerp(startPos, nowTergetPos, time)
```

#### 球型插值

```csharp
Vector3.Slerp(start, end, t);
Transform A;
// 1 匀速移动
float time;
time += Time.deltaTime;
A.position = Vector3.Slerp(Vector3.right * 10, Vector3.forward * 10, time)
//A从 (10, 0, 0) 沿弧线 移动到 (0, 0, 10)
//这里同样也要更新开始点、目标点和时间 因为只是演示 没有补全逻辑

// 2 先快后慢
```

---

#### 区别

| 名称   | 区别                                        |
| ---- | ----------------------------------------- |
| 线性插值 | ![[向量线性插值.png\|226]]                      |
| 插值球型 | ![[向量球型插值.png\|257]] |

---

### 代码演示

```csharp
//向量加法
transform.position += new Vector3(0, 0, 5);//平移
transform.TransLate(Vector3.forward * 5);// 本质上也是在进行平移

//向量减法
transform.position -= new Vector3(0, 0, 5);//平移
transform.TransLate(-Vector3.forward * 5);//更常用

//向量乘除标量 缩放大小的调整
transform.localScale *= 2;
transform.localScale /= 2;

//向量点乘
// 1 判断 B 在 A面朝向 前方还是后方
Vector3.Dot(向量A, 向量B)
Transform A;
Transform B;
float dotResult = Vector3.Dot(A.forward, B.position - A.position);
if (dotResult >= 0) 
	Print("在前方"); 
else
	Print("在后方");

// 2 根据推导公式算出夹角
//β = Acos(单位向量A · 单位向量B)
dotResult = Vector3.Dot(A.forward, (B.position - A.position).normalized);
Math.Acos(dotResult) * Mathf.Rad2Deg;
Vector3.Angle(A.forward, B.position - A.position);//这个方法和上面达成的目的一致
//得到的角度最大为180°

//向量叉乘
// 判断 B 在 A面朝向 左方还是右方
Vector3.Cross(向量A, 向量B)
//下面的 Vector3 不代表位置 代表从坐标轴原点出发到达 A、B 点的向量
Transform A;
Transform B;
Vector3 cross = Vector3.Cross(A.forward, B.position)
if (cross.y > 0)
	Print("在右方"); 
else
	Print("在左方"); 
```

### 练习

> 1. 用向量相关知识，实现摄像机跟随(摄像机不设置为对象子物体)摄像机一直在物体的后方4米，向上偏7米的位置 
![[向量加减乘除练习.png|212]]

```csharp
public class Vector_CameraFollow : MonoBehaviour
{
	public zOffect = 4;
	public yOffect = 7;
    public Transform target;
    void LateUpdate()
    {
        transform.position = target.position + -target.forward * zOffect + target.up * yOffect;
    }
}
```

> 2. 当一个物体B在物体A前方45度角范围内，并且离A只有5米距离时，在控制台打印"发现入侵者"
![[向量点乘练习.png|147]]

```csharp
public class Vector_Angle : MonoBehaviour
{

    public Transform target;
    private Vector3 distance;
    void Update()
    {
        distance = target.position - transform.position;
        float angle = Mathf.Acos(Vector3.Dot(transform.forward, distance.normalized)) * Mathf.Rad2Deg;//方法一 公示推导
        angle = Vector3.Angle(transform.forward, distance);//方法二 Angle
        if (angle <= 22.5f && distance.magnitude <= 5)
        {
            print("发现入侵者！");
        }
    }
}
```

> 3. 判断一个物体B位置再另一个物体A的位置的左上，左下，右上，右下哪个方位

```csharp
public class Vector_Cross : MonoBehaviour
{
    public Transform A;
    public Transform B;
    float cross;
    float dot;
    Vector3 distance;

    void Update()
    {
        distance = B.transform.position - A.transform.position;
        cross = Vector3.Cross(A.forward, distance).y;
        dot = Vector3.Dot(A.forward, distance);
        if (distance.magnitude <= 5)
        {
            if (cross >= 0)
            {
                if (dot >= 0)
                {
                    print("右前");
                }
                else
                {
                    print("右后");
                }
            }
            else
            {
                if (dot >= 0)
                {
                    print("左前");
                }
                else
                {
                    print("左后");
                }
            }
        }
    }
}
```

> 4. 当一个物体B在物体A左前方20度角或右前方30度范围内，并且离A只有5米距离时，在控制台打印“发现入侵者”
![[向量叉乘练习.png|169]]

```csharp
public class Vector_Cross : MonoBehaviour
{
    public Transform A;
    public Transform B;
    float cross;
    float dot;
    Vector3 distance;
    void Update()
    {
        distance = B.transform.position - A.transform.position;
        cross = Vector3.Cross(A.forward, distance).y;
        dot = Vector3.Dot(A.forward, distance);
        if (distance.magnitude <= 5)
        {
            if (cross < 0 && dot >= 0 && Vector3.Angle(A.forward, distance) <= 20)
            {
                print("左侧20°内\n发现敌人");
            }
            if (cross >= 0 && dot >= 0 && Vector3.Angle(A.forward, distance) <= 30)
            {
                print("右侧30°内\n发现敌人");
            }
        }
    }
}
```

> 5. 用线性插值相关知识，实现摄像机跟随(摄像机不设置为对象子物体)摄像机一直在物体的后方4米，向上偏7米的位置

```csharp
public class Vector_Lerp : MonoBehaviour
{
    public Transform target;
    Vector3 nowTarget;
    Vector3 startPos;
    Vector3 tarGetPos;
    float time;
    public float moveSpeed = 0;

    void Update()
    {
        tarGetPos = target.position + -target.forward * 4 + target.up * 7;

        if (nowTarget != tarGetPos)
        {
            time = 0;
            startPos = transform.position;
            nowTarget = tarGetPos;
        }
        time += Time.deltaTime;
        transform.position = Vector3.Lerp(startPos, nowTarget, time * moveSpeed);
    }
}
```

> 6. 通过球形插值模拟太阳的升降变化

```csharp
public class Vector_Slerp : MonoBehaviour
{
    float time;
    void Update()
    {
        time += Time.deltaTime;
        transform.position = Vector3.Slerp(Vector3.right * 100, Vector3.left * 100 + Vector3.up * 0.5, time * 0.1);
    }
}
```

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- 向量基础
	- 两点决定距离：得到代表两点距离的向量
	- 向量的模：得到两点距离
	- 单位向量：用来进行移动计算
	- 负向量：让物体反着动
- 向量加减乘除
	- 加法：位置平移和向量计算
	- 减法：位置平移和向量计算
	- 乘除法：模长放大缩小
- 向量点乘
	- 判断对象的方位
	- 计算两个向量之间的夹角 视锥体检测（FOV）
- 向量叉乘
	- 得到一个平面的法向量
	- 得到两个向量之间的左右位置关系
- 插值运算
	- 线性插值
		- 跟随移动 摄像机跟随
	- 球型插值
		- 曲线运动 模拟太阳运动弧线 模拟导弹运动

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 计算A指向B的向量 是B - A

---

## API 速查

- Vector3.magnitude （属性 得到向量模长）
- Vector3.normalized （属性 得到单位向量）
- Vector3.Dot（方法 点乘）
- Vector3.Angle （方法 得到两个向量的夹角）
- Vector3.Lerp （方法 向量插值运算）

---

## 我的踩坑记录

> ⭐ 这里最有价值！把自己犯过的错误写下来，写上日期

- Dot、Angle的参数一定要 传入两个向量 而不是位置

---

## 延伸阅读

> 这个知识点延伸出去的方向，学完后可以探索

- [[]]相关知识点
- 

---

*最后更新：*
