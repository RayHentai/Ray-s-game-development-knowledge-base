# 05 Quaternion四元数

**所属模块**：[[00 Unity 基础阶段总览]]
**关联**：[[14 Transform 位移旋转缩放]] | [[02 三角函数]] | [[04 Vector向量]]
**查阅次数**：1

---

## 四元数基础

---

### 欧拉角

> 由三个角度(x,y,z)组成，在特定坐标系下用于描述物体的旋转量

- 空间中的任意旋转都可以分解成绕三个互相垂直轴的三个旋转角组成的序列

**旋转约定：**
heading-pitch-bank，是一种最常用的旋转序列约定Y-X-Z约定
- heading:物体绕自身的对象坐标系的Y轴，旋转的角度
- pitch:物体绕自身的对象坐标系的X轴，旋转的角度
- bank:物体绕自身的对象坐标系的Z轴，旋转的角度

**Unity中的欧拉角：**
- Inspector窗口中调节的`Rotation` 显示的就是欧拉角
- `transform.eulerAngles` 得到的角度就是欧拉角角度

**优缺点：**
- **优点**
	- 直观、易理解
	- 存储空间小（三个数表示）
	- 可以进行从一个方向到另一个方向旋转大于180°的角度

- **缺点**
	- 同一旋转的表示不唯一（90°和 450°）
	- 万向节死锁

**万向节死锁：**
- 当某个特定轴达到某个特殊值时，绕一个轴旋转可能会覆盖住另一个轴的旋转从而**失去一维自由度**
- Unity中X轴达到90度时会产生万向节死锁（旋转y轴和z轴都是沿z轴旋转）

---

## 四元数

---

### 四元数的构成

- 四元数是简单的超复数，由实数加上三个虚数单位组成，主要用于在三维空间中表示旋转
- 四元数原理包含大量数学相关知识，较为复杂比如：复数、四维空间等等
- 因此此处我们只对其基本构成和基本公式进行讲解，如想深入了解数学原理请从数学层面去查找资料了解它

**一个四元数包含一个标量和一个3D向量：**
`[W,V]`，w为标量，v为3D向量
`[W, (x,y,z)]`
对于给定的任意一个四元数：表示3D空间中的一个旋转量

**轴-角对:**
在3D空间中，任意旋转都可以表示绕着某个轴旋转一个旋转角得到
**注意：** 该轴并不是空间中的x,y,z轴，而是任意一个轴（任意向量的方向）

**公式：**
> 对于给定旋转，假设为绕着n轴，旋转β度，n轴为(x,y,z)那么可以构成四元数为

四元数 Q=`[cos(β / 2)，sin(β / 2)n]`
四元数 Q = `[cos(β / 2)，sin(β / 2)x, sin(β / 2)y, sin(β / 2)z]`

**四元数 Q 则表示绕着轴 n，旋转 β 度的旋转量**

---

### 单位四元数

**单位四元数表示没有旋转量（角位移）**
- 当角度为0或者360度时
- 对于给定轴都会得到单位四元数
- `[1,(0,0,0)]` 和 `[-1,(0,0,0)]` 都是单位四元数表示没有旋转量

```csharp
Quaternion.identity
Instantiate(obj, Vector3.zero, Quaternion.identity);//在世界坐标系原点 实例化一个没有旋转角度的对象
```

---

## Unity中的四元数

>Quaternion，是表示四元数的结构体

**注意：一般不会直接通过四元数的 w,x,y,z 进行修改**

---

### 初始化

```csharp
//轴角对公式初始化 了解 一般不会这么用
//四元数 Q =[cos(β/2)，sin(β/2)x, sin(β/2)y, sin(β/2)z]
Quaternion Quaternion = new Quaternion(sin(β / 2)x, sin(β / 2)y, sin(β / 2)z, cos(β / 2));
//让物体沿正朝向移动60度 Vector3.forward(0, 0, 1)
Quaternion q = new Quaternion(Mathf.Sin(30 * Mathf.Deg2Rad) * 0, Mathf.Sin(30 * Mathf.Deg2Rad) * 0, Mathf.Sin(30 * Mathf.Deg2Rad) * 1, Mathf.Cos(30 * Mathf.Deg2Rad));
transform.rotation = q;

//轴角对方法初始化
四元数 Q = Quaternion.AngleAxis(角度, 轴);//相当于封装了上面那种写法
Quaternion Quaternion = Quaternion.AngleAxis(60, Vector3.right);
```

---

### 欧拉角 和 四元数 转化

```csharp
// 1 欧拉角 转 四元数
Quaternion q = Quaternion.Euler(x轴角度, y轴角度, z轴角度);
// 2 四元数 转 欧拉角
q.eulerAngles
```

---

### 弥补欧拉角的缺点（四元数相乘）

- 同一旋转的表示不唯一
	- 四元数只能取到 180° ~ －180° 刚好转一圈
- 万向节死锁

```csharp
//e.x = 90;
Vector3 e = transform.rotate.eulerAngles;
e += Vector3.up; e += Vector3.forward;
transform.rotate.Euler(e);//此时e的两种计算 因为万向节死锁 最终显示的效果都一样 

//四元数相乘 代表旋转四元数
//这里的Vector3.forward 代表相对自己的坐标系 不是相对世界的坐标系
transform.rotate *= Quaternion.AngleAxis(1, Vector3.forward);//沿z轴旋转1度
transform.rotate *= Quaternion.AngleAxis(1, Vector3.up);//沿y轴旋转1度
//此时 就不存在万向节死锁问题 物体会沿着对应轴旋转
```

---

### 常用方法

```csharp
//插值运算 [[01 数学计算公共类Mathf#^635a36]] | [[01 数学计算公共类Mathf#^34e3f8]]
//在四元数中 Lerp 和 Slerp的表现形式是一样的 只要一些细微差别
//由于算法差异 Slerp的效果会好一些
//Lerp的效果相比Slerp更快 但是如果旋转范围较大效果较差
//所以建议使用Slerp进行插值运算
// 1 先快后慢
Transform A;
Transform target;
A.transform.rotation = Quaternion.Slerp(A.transform.rotation, target.rotation, Time.deataTime);

// 2 匀速运动
Quaternion start;
float time;
start = A.transform.rotation;
Time += Time.deltaTime;
A.transform.rotation = Quaternion.Slerp(start, target.rotation, time);

//向量指向转四元数
Quaternion.LookRotation(面朝向量);
//LookRoataion方法可以将传入的面朝向量 转换为 对应的四元数角度信息
//举例：当人物面朝向想要改变时，只需要把目标面朝向传入该函数，便可以得到目标四元数角度信息，之后将人物四元数角度信息改为得到的信息即可达到转向
Transform lookA;
Quaternion q = Quaternion.LookRotation(lookA.position - transform.position);
transform.rotation = q;
```

---

#### 练习

> 1. 为Transform拓展一个方法，通过四元数的LookRotation方法，实现LookAt的效果

```csharp
public static class Quaternion_Tool
{
    public static void MyLookAt(this Transform obj, Transform target) 
    {
        Vector3 v = target.position - obj.position;
        obj.rotation = Quaternion.LookRotation(v);
    }
}

public class Quaternion_LookRotation : MonoBehaviour
{
    public Transform target;
    void Update()
    {
        transform.MyLookAt(target);
    }
}
```

>  2. 将之前摄像机移动的练习题中的LookAt换成LookRotation实现并且通过Slerp来缓慢看向玩家 

```csharp
//[[04 Vector向量]]
public class Quaternion_Slerp : MonoBehaviour
{
    public Transform target;
    private Vector3 tarGetPos;
    private Vector3 nowTarget;
    private Vector3 startPos;
    private float time;
    private Quaternion start;
    private Quaternion nowRotation;
    private Quaternion targetRotation;
    private float roundTime;

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
        transform.position = Vector3.Lerp(startPos, nowTarget, time);


        targetRotation = Quaternion.LookRotation(target.position - transform.position);
        if (nowRotation != targetRotation)
        {
            nowRotation = targetRotation;
            start = transform.rotation;
            roundTime = 0;
        }
        roundTime += Time.deltaTime;
        transform.rotation = Quaternion.Lerp(start, nowRotation, roundTime);
    }
}

```

---

## 四元数的计算

---

### 四元数 相乘

**公式：**
- q3 = q1 * q2
- 两个四元数相乘得到一个新的四元数代表两个旋转量的叠加（相当于旋转）
- **注意：** 旋转相对的坐标系 是物体自身坐标系

```csharp
Quaternion q = Quaternion.AngleAxis(20, Vector3.up);
transform.rotate *= q; //沿y轴转20度
transform.rotate *= q; //沿y轴再转20度
//此时Transform面板可能与旋转的角度不一致 因为旋转相对的是物体自身坐标系
```

---

### 四元数 乘 向量

**公式：**
- v2 = q1 * v1
- 四元数乘向量返回一个新向量
- 可以将指定向量旋转对应四元数的旋转量相当于旋转向量
- 相乘的顺序不能概念 四元数在前 如果是向量在前会报错

```csharp
Vector3 v = Vector3.forward; //(0, 0, 1)
v = Quaternion.AngleAxix(45, Vector3.up) * v; //(0.7, 0, 0.7)
v = Quaternion.AngleAxix(45, Vector3.up) * v;  //(1, 0, 0)
v *= Quaternion.AngleAxix(45, Vector3.up); //报错
```

---

### 练习

> 1. 用目前所学知识，模拟飞机发射不同类型子弹的方法单发，双发，扇形，环形

```csharp
public enum E_FireType
{
    one,
    two, 
    three, 
    four,
}
public class Quaternion_Shoot : MonoBehaviour
{
    public GameObject bullet;
    private E_FireType type;
    public int shootNum;
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
            type = E_FireType.one;
        if (Input.GetKeyDown(KeyCode.Alpha2))
            type = E_FireType.two;
        if (Input.GetKeyDown(KeyCode.Alpha3))
            type = E_FireType.three;
        if (Input.GetKeyDown(KeyCode.Alpha4))
            type = E_FireType.four;
        if (Input.GetKeyDown(KeyCode.Space))
            Fire();
    }
    public void Fire()
    {
        switch (type)
        {
            case E_FireType.one:
                Instantiate(bullet, transform.position, transform.rotation);
                break;
            case E_FireType.two:
                Instantiate(bullet, transform.position + transform.right * 0.5f, transform.rotation);
                Instantiate(bullet, transform.position + -transform.right * 0.5f, transform.rotation);
                break;
            case E_FireType.three:
                Instantiate(bullet, transform.position, transform.rotation);
                Instantiate(bullet, transform.position, transform.rotation * Quaternion.AngleAxis(20, Vector3.up));
                Instantiate(bullet, transform.position, transform.rotation * Quaternion.AngleAxis(-20, Vector3.up));
                break;
            case E_FireType.four:
                float angle = 360 / shootNum;
                for (int i = 0; i < shootNum; i++)
                    Instantiate(bullet, transform.position, transform.rotation * Quaternion.AngleAxis(i * angle, Vector3.up));
                break;
        }
    }
}
```

^60d844

> 2. 用所学3D数学知识实现摄像机跟随效果

1. 摄像机在人物斜后方，通过角度控制倾斜率
2. 通过鼠标滚轮可以控制摄像机距离人物的距离 (有最大最小限制)
3. 摄像机看向人物头顶上方一个位置 (可调节)
4. Vector3.Lerp实现相机跟随人物
5. Quaternion.Slerp实现摄像机朝向过渡效果

```csharp
public class Quaternion_CameraFollow : MonoBehaviour
{
    public Transform target;
    //一些可调整参数
    public float LookAtPos = 1;
    public float angle = 45;
    public float dis = 5;
    public float maxDis = 10;
    public float minDis = 3;
    //临时变量 位置偏移的向量 和 计算完之后的目标位置
    private Vector3 moveVector;
    private Vector3 nowPos;
    //位置 线性插值的临时变量
    private Vector3 targetPos;
    private Vector3 nowTargetPos;
    private Vector3 startPos;
    private float timePos;
    //旋转 线性插值的临时变量
    private Quaternion targetRot;
    private Quaternion nowTargetRot;
    private Quaternion startRot;
    private float timeRot;
    void Update()
    {
        //检测滚轮输入 用于计算 摄像机距离
        dis += Input.GetAxis("Mouse ScrollWheel");
        //前置函数 用于返回范围内的值
        dis = Mathf.Clamp(dis, minDis, maxDis);
        //得到摄像机偏移特定角度所移动的向量
        moveVector = Quaternion.AngleAxis(angle, target.right) * -target.forward;
        //当前目标位置 = 目标位置 + 头顶偏移值 + 计算倾斜率得到的单位向量 * 距离
        nowPos = target.position + transform.up * LookAtPos + moveVector * dis;
        targetPos = nowPos;
        Debug.DrawLine(transform.position, target.position + transform.up * LookAtPos);
        //匀速跟随移动
        if (targetPos != nowTargetPos)
        {
            nowTargetPos = targetPos;
            timePos = 0;
            startPos = transform.position;
        }
        timePos += Time.deltaTime;
        transform.position = Vector3.Lerp(startPos, nowTargetPos, timePos);
        //匀速看向目标
        //LookRotation 的参数 就是 前面得到的 摄像机到目标位置的 向量 的 反向量
        targetRot = Quaternion.LookRotation(-moveVector);
        if (targetRot != nowTargetRot)
        {
            nowTargetRot = targetRot;
            timeRot = 0;
            startRot = transform.rotation;
        }
        timeRot += Time.deltaTime;
        transform.rotation = Quaternion.Slerp(startRot, nowTargetRot, timeRot);
    }
}
```

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- 单位四元数：初始化对象，重置角度
- 插值运算：平滑旋转
- 向量指向四元数：让对象朝向某方向
- 四元数相乘：旋转物体
- 四元数乘向量： 旋转向量 计算开火方向

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- Unity Inspector窗口的Rotation 显示的是欧拉角 但是 transform.rotation 代表四元数
- 在Quaternion * Vector3 中 旋转轴是 Quaternion.AngleAxis(60, Vector3) 中的Vector3 被旋转的轴是 Vector3 这个向量

---

## API 速查

- Quaternion.AngleAxis （方法 快速初始化四元数）
- Quaternion.Euler （方法 欧拉角转四元数）
- Quaternion.Lerp （方法 线性插值运算）
- Quaternion.Slerp （方法 球型插值运算）
- Quaternion.LookRotation（方法 向量指向转四元数）
- Quaternion.eulerAngles（属性 四元数转欧拉角）
- Quaternion.identity （属性 单位四元数）

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
