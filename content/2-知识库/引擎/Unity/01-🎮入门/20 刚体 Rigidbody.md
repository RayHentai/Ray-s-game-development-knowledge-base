# ⚙️ 20 刚体 Rigidbody

**所属模块**：[[00 Unity入门阶段总览]]
**关联**：[[19 物理系统与碰撞检测]]
**查阅次数**：0

---

## 刚体主要参数

- Mass  
    质量 (默认为千克)
    - 质量越大惯性越大
- Drag  
    空气阻力
    - 根据力移动对象时影响对象的空气阻力大小
    - 0表示没有空气阻力
- Angular Drag  
    扭矩阻力
    - 根据扭矩旋转对象时影响对象的空气阻力大小
    - 0表示没有空气阻力
- Use Gravity  
    是否受重力影响
- Is Kinematic
    - 如果启用此选项 则对象将不会被物理引擎驱动 只能通过(Transform)对其进行操作
    - 对于移动平台 或者如果要动画化附加了HingeJoint 的刚体 此属性将非常有用
- Interpolate  
    插值运算  
    让刚体物体移动更平滑
    - None  
        不应用插值运算
    - Interpolate  
        根据前一帧的变换来平滑变换
    - Extrapolate  
        差值运算  
        根据下一帧的估计变换来平滑变换  
- CollisionDetection  
    碰撞检测模式  
    用于防止快速移动的对象穿过其它对象而不检测碰撞  
    - ![[CollisionDetection.png]]
    - Discrete(离散检测)
        - 对场景中的所有其他碰撞体使用离散碰撞检测 其他碰撞体在测试碰撞时会使用离散碰撞检测 用于正常碰撞(这是默认值)
    - Continuous(连续检测)
        - 对动态碰撞体（具有刚体）使用离散碰撞检测并对静态碰撞体（没有刚体）使用连续碰撞检测
        - 设置为连续动态(Continuous Dynamic)的刚体将在测试与该刚体的碰撞时使用连续碰撞检测（此属性对物理性能有很大影响，如果没有快速对象的碰撞问题，请将其保留为Discrete设置)
        - 其他刚体将使用离散碰撞检测
    - Continuous Dynamic(连续动态检测)性能消耗高
        - 对设置为连续(Continuous)和连续动态 (Continuous Dynamic)碰撞的游戏对象使用连续碰撞检测 还将对静态碰撞体（没有刚体）使用连续碰撞检测
        - 对于所有其他碰撞体 使用离散碰撞检测
        - 用于快速移动的对象
    - Continuous Speculative(连续推测检测)
        - 对刚体和碰撞体使用推测性连续碰撞检测 该方法通常比连续碰撞检测的成本更低
- Constraints  
    约束  
    对刚体运动的限制
    - Freeze Position  
        有选择地停止刚体沿世界X、Y和Z轴的移动
    - Freeze Rotation  
        有选择地停止刚体围绕局部X、Y和Z轴旋转

---

## 刚体加力

>给刚体加力的目标就是 让其有一个速度 朝一个方向移动

```csharp
Rigidbody rb = GetComponent<Rigidbody>();

// 加力
rb.AddForce(Vector3.forward); // 世界坐标系z轴正方向加力
rb.AddRelativeForce(Vector3.forward); // 相对本地坐标方向加力
rb.AddForce(this.transform.forword) //和上一句代码一样

// 力矩（旋转）
rb.AddTorque(Vector3.up);//世界坐标系 y轴正方向加力
rb.AddRelativeTorque(Vector3.up)//本地坐标系 y轴正方向加力
rb.AddTorque(this.transform.up)//和上一句代码一样

// 改变速度
rb.velocity = Vector3.forward * 10;

// 休眠检测
if (rb.IsSleeping()); // 刚体是否在休眠 返回bool值
	rb.WakeUp(); // 唤醒刚体

//爆炸效果模拟 只会对调用了该方法的对象生效
rb.AddExplosionForce(10, Vector3.zero, 10)  //力, 位置, 半径​

//Constant Forse 力场脚本名 这个脚本可以一直给与对象一些力
```

^fdf488

---

## 力的几种模式

```csharp
//动量定理
Ft = mv
v = Ft/m
F：力   T：时间   m：质量   v：速度

//模式
//Acceleration 给物体增加一个持续的加速度 忽略其质量
v = Ft / m
F:(0,0,10)
t:0.02s
m：默认为1
v= 10 * 0.02 / 1 = 0.2 m/s
每物理帧移动 0.2 m/s * 0.02 = 0.004m

//Force 给物体添加一个持续的力 与物体的质量有关
V = Ft / m
F:(0,0,10)
t:0.02s
m:2kg
v= 10 * 0.02 / 2 = 0.1 m/s
每物理帧移动 0.1 m/s * 0.02 = 0.002m

//Impulse 给物体添加一个瞬间的力 与物体的质量有关 忽略时间 默认为1
V= Ft / m1
F:(0,0,10)
t:默认为1
m:2kg
V=10 * 1 / 2 = 5 m/s
每物理帧移动 5 m/s * 0.02 = 0.1m

//VelocityChange 给物体添加一个瞬时速度 忽略质量
v = Ft / m
F:(0,0,10)
t：默认为1
m：默认为1
v = 10 * 1 / 1 = 10 m/s
每物理帧移动 10 m/s * 0.02 = 0.2m
```

---

## 让物体产生位移的方式

```csharp
// ① 直接改变 Transform.position
transform.position += Vector3.forward * speed * Time.deltaTime;

// ② 使用 Transform.Translate
transform.Translate(Vector3.forward * speed * Time.deltaTime);

// ③ 刚体加力
rb.AddForce(Vector3.forward * force);
rb.AddRelativeForce(Vector3.forward * force);

// ④ 改变刚体速度
rb.velocity = Vector3.forward * 10;
```

---

## 练习

> 1. 请问现在让一个物体产生位移有几种方式？

```
① 直接在 Update 生命周期函数中改变 Transform 的 Position 属性
② 直接在 Update 生命周期函数中使用 Transform 提供的 Translate 方法
③ 通过加力：
   rigidbody.AddForce(...)
   rigidbody.AddRelativeForce(...)
④ 通过改变刚体速度变量：
   rigidbody.velocity = Vector3.forward * 10;
```

---

## 我的踩坑记录

- Is Kinematic 勾选后，物体只能通过 Transform 控制，不受重力和碰撞力影响

---

*最后更新：*
