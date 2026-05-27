# 📐 14 Transform 位移旋转缩放

**所属模块**：[[00 Unity入门阶段总览]]
**关联**：[[03 Unity中的坐标系]] | [[11 MonoBehavior 重要内容]] | [[04 Vector向量]]
**查阅次数**：2

---

## 核心理解

> **必不可少的 Transform**：GameObject 位移、旋转、缩放、父子关系、坐标转换等相关操作都由它处理。

---

## 位置和位移

---

### Vector3基础

> 标识三维坐标系中的一个点或一个向量。


```csharp
//声明
Vector3 v = new Vector3();
Vector3 v = new Vector3(x, y); //只传xy z默认是0
Vector3 v = new Vector3(x, y, z);

//运算符 + - * /

//常用初始值
Vector3.forward // (0, 0, 1)  前方
Vector3.back // (0, 0, -1) 后方
Vector3.up // (0, 1, 0)  上方
Vector3.down // (0, -1, 0) 下方
Vector3.right // (1, 0, 0)  右方
Vector3.left // (-1, 0, 0) 左方
Vector3.zero // (0, 0, 0)
Vector3.one // (1, 1, 1)

//常用方法 Distance
Vector3.Distance(v1, v2); //计算两点之间的距离
```

---

### 位置

**注意：位置的赋值不能直接改变xyz 只能整体改变**

```csharp
// 相对世界坐标系
this.transform.position

// 相对父对象的本地坐标
// 如果子对象想以面板为准设置坐标 一定是通过 localPosition 设置
this.transform.localPosition

//对象当前的各朝向
this.transform.forward //对象当前的面朝向 
this.transform.up //对象当前的头顶朝向 
this.transform.forward  //对象当前的右手边
//...

//位置的赋值 三种方式
this.transform.position.x = 10; ❌
this.transform.position = new Vector3(10, 10, 10);

this.transform.position = new Vector3(10, this.transform.position.y, this.transform.position.z);

Vector3 vPos = this.transform.position;
vPos.z = 10;
this.transform.position = vPos
```


---

### 位移（Translate）

>**公式：路程 = 方向（偏移） * 速度 * 时间**

因为 用的是transfrom.forward 所所以它始终会朝着相对于自己的面朝向去动 如果改成Vector3.方向 就是朝着世界坐标系去动

```csharp
//自己计算
//现在的位置 += 正朝向 * 速度 * 时间
this.transfrom.position += this.transfrom.forward * 1 * Time.deltaTime

//调用API Translate
//参数1 位移的距离 
//参数2 相对坐标系 默认为相对自己的坐标系
//相对世界坐标系z轴正方向移动（Space.World）
this.transform.Translate(Vector3.forward * speed * Time.deltaTime, Space.World);

//相对自身坐标系z轴正方向移动（Space.Self，默认）
this.transform.Translate(Vector3.forward * speed * Time.deltaTime);
this.transform.Translate(Vector3.forward * speed * Time.deltaTime, Space.Self);

//相对世界坐标系，朝自己面朝向移动（最常用）和上面的移动轨迹是一样的
this.transform.Translate(this.transform.forward * speed * Time.deltaTime, Space.World);

// 相对自己的坐标系 朝自己的面朝向移动（一般不会这样动）
this.transfrom.Translate(this.transfrom.forward * 1 * Time.deltaTime, Space.Self)
```

---

### 练习

> 1. 一个空对象上挂了一个脚本，这个脚本可以让游戏运行时，在场景中创建出一个n层由Cube构成的金字塔（提示：实例化预设体或者实例化自带几何体方法）

```csharp
public class Jinzita : MonoBehaviour
{
    public int num;

    void Start()
    {
        for (int i = 0; i < num; i++)
        {
            Vector3 v = new Vector3(-0.5f * i, -1 * i, 0.5f * i);
            for (int j = 0; j < (i + 1) * (i + 1); j++)
            {
                GameObject obj = GameObject.CreatePrimitive(PrimitiveType.Cube);
                obj.transform.position = v + new Vector3(j % (i + 1) * 1, 0, j / (i + 1) * -1);
            }
        }
    }
}
```


> 2. 这四个方法，哪些才能让对象朝自己的面朝向移动？为何？

```csharp
this.transform.Translate(Vector3.forward, Space.World); // ① 相对世界坐标系朝 Z 轴正方向
this.transform.Translate(Vector3.forward, Space.Self); // ② 相对自己坐标系朝 Z 轴正方向 ✅
this.transform.Translate(this.transform.forward, Space.Self); // ③ 相对自己坐标系朝自己 Z 轴正方向
this.transform.Translate(this.transform.forward, Space.World); // ④ 相对世界坐标系朝自己 Z 轴正方向 ✅

// ② 朝自己的面朝向：因为相对自己坐标系，forward 就是自己的前方
// ④ 朝自己的面朝向：因为 this.transform.forward 本身就是自己朝向
```

> 3. 使用之前创建的坦克预设体，让其可以朝自己的面朝向向前移动

```csharp
// 两种方法均可
transform.Translate(Vector3.forward * 1 * Time.deltaTime); // 方法1
transform.Translate(transform.forward * 1 * Time.deltaTime, Space.World); // 方法2
```

---

## 角度和旋转

---

### 角度

**注意：**
- 设置角度和设置位置一样 不能单独设置xyz 要一起设置
- 通过欧拉角得到的角度 不会出现复数

```csharp
// 欧拉角（Inspector 显示的角度值）
this.transform.eulerAngles // 相对世界坐标欧拉角
this.transform.localEulerAngles // 相对父对象欧拉角

// Quaternion 四元数（内部存储方式，万向锁免疫）
this.transform.rotation
this.transform.localRotation
```

---

### 旋转（Rotate）

```csharp
//自己计算

//API
//自转（绕自身轴）
//参数1 表示旋转的 角度 / 帧
//参数2 表示相对坐标系 默认是自己的坐标系
//每个轴具体转多少度
this.transform.Rotate(new Vector3(0, 10, 0) * speed * Time.deltaTime);

//相对某个轴转多少度
//多了一个参数 表示轴
this.transform.Rotate(Vector3.up, speed * Time.deltaTime);
this.transfrom.Rotate(Vector3.up, speed * Time.deltaTime, Space.World)//相对世界坐标的Y轴转

// 绕某个点旋转（公转）
//参数1 围着哪个点转
//参数2 相对这个点的哪个轴转圈
//参数3 转的角度 * 时间
this.transform.RotateAround(目标点.position, Vector3.up, speed * Time.deltaTime);
```

---

### 练习

> 1. 使用你之前创建的坦克预设体，在坦克下面加一个底座（用自带几何体即可）让其可以原地旋转，类似一个展览台

> 2. 在第4题的基础上，让坦克的炮台可以自动左右来回旋转，炮管可以自动上下抬起

> 3. 请用3个球体，模拟太阳、地球、月亮之间的旋转移动

```csharp
public class zhuan : MonoBehaviour
{
    public float rotateSpeed = 10;
    public float headRotateSpeed = 10;
    public float ptRotateSpeed = 10;
    
    public Transform headPos;
    public Transform ptPos;
    public Transform sonPos;
    public Transform earthPos;
    public Transform moonPos;
    
    void Update()
    {
        //this.transform.Rotate(new Vector3(0,10,0) * Time.deltaTime);
        this.transform.Rotate(Vector3.up, rotateSpeed * Time.deltaTime);

        headPos.Rotate(Vector3.up, headRotateSpeed * Time.deltaTime);
        if (!(headPos.localEulerAngles.y >=315 && headPos.localEulerAngles.y <= 360) && 
            headRotateSpeed > 0 && headPos.eulerAngles.y >= 45)
            headRotateSpeed = -headRotateSpeed;
        else if (!(headPos.localEulerAngles.y <= 45 && headPos.localEulerAngles.y >= 0) && 
            headRotateSpeed < 0 && headPos.localEulerAngles.y <= 315)
            headRotateSpeed = -headRotateSpeed;

        ptPos.Rotate(Vector3.right, ptRotateSpeed * Time.deltaTime);
        if (!(ptPos.localEulerAngles.x >= 350 && ptPos.localEulerAngles.x <= 360) &&
            ptRotateSpeed > 0 && ptPos.eulerAngles.x >= 10)
            ptRotateSpeed = -ptRotateSpeed;
        else if (!(ptPos.localEulerAngles.x <= 10 && ptPos.localEulerAngles.x >= 0) &&
            ptRotateSpeed < 0 && ptPos.localEulerAngles.x <= 350)
            ptRotateSpeed = -ptRotateSpeed;

        sonPos.Rotate(new Vector3(0,100,0) * Time.deltaTime);
        earthPos.Rotate(new Vector3(0, 100, 0) * Time.deltaTime);
        moonPos.Rotate(new Vector3(0, 100, 0) * Time.deltaTime);
    }
}
```


---

## 缩放和看向

---

### 缩放

**注意：**
- 设置缩放不能单独设置xyz 要一起设置
- 相对于世界坐标系的缩放大小只能得 不能改
- Unity没有提供关于缩放的Api

```csharp
this.transform.lossyScale  // 相对世界坐标系
this.transform.localScale  // 相对父对象坐标系
// 注意：没有 scale（世界缩放），缩放只有 localScale
```

---

### 看向

>让一个对象的面朝向 可以一致看向某一个点或某一个对象

```csharp
// 让对象的 Z 轴正方向朝向目标
this.transform.LookAt(Transform);
this.transform.LookAt(目标.transform);
```

---

### 练习

> 1. 使用之前的坦克预设体，让摄像机可以跟随其移动，并且一直看向坦克

```csharp
public class LookAt : MonoBehaviour
{
    public Transform tank;

    void Update()
    {
        transform.LookAt(tank);
    }
}
```

---

## 父子关系

```csharp
// 获取父对象
Transform parent = this.transform.parent;

// 设置父对象
//手动
this.transform.parent = null;//断绝关系
this.transform.parent = 对象.transform;
//API
//参数1 对象
//参数2 是否保留世界坐标信息 
this.transform.Setparent(null);
this.transform.Setparent(对象.transform);

//和所有儿子断绝关系
this.transform.DetachChildren();

//儿子的操作
this.transform.Find("对象名");//获取子对象 能找到失活对象 只能找到儿子 不能找到孙子
int count = this.transform.childCount; // 子对象数量
Transform child = this.transform.GetChild(i); // 获取第 i 个子对象
 if (this.transfrom.IsChildOf(对象.transform))//判断自己的爸爸
this.transfrom.GetSiblingIndex();//得到自己作为儿子的编号
this.transfrom.SetAsFirstSibling();//把自己设置为第一个儿子
this.transfrom.SetAsLastSibling();//把自己设置为最后一个儿子
this.transfrom.SetSiblingIndex(编号);//把自己设置为指定个儿子 如果传入的编号超出范围 会直接设置到最后一个  
```

---

### 练习

 > 1. 请为 Transform 写一个拓展方法，可以将它的子对象按名字的长短进行排序，名字短的在前面

```csharp
public static class Tool
{
    public static void Sort(this Transform obj)
    {
        List<Transform> temp = new List<Transform>();
        for (int i = 0; i < obj.childCount; i++)
            temp.Add(obj.GetChild(i));

        temp.Sort((a, b) => a.name.Length < b.name.Length ? -1 : 1);

        for (int i = 0; i < temp.Count; i++)
            temp[i].SetSiblingIndex(i);
    }
}
```

> 2. 请为 Transform 写个拓展方法，传一个名字查找子对象，即使是子对象的子对象也能查找到

```csharp
public static class Tool
{
    public static Transform FindSon(this Transform father, string name)
    {
        Transform son = father.Find(name);
        if (son != null) 
	        return son;

        for (int i = 0; i < father.childCount; i++)
        {
            son = father.GetChild(i).FindSon(name);
            if (son != null) 
	            return son;
        }
        return son;
    }
}
```


---

## 坐标转换

```csharp
// 本地坐标 → 世界坐标
this.transform.TransformPoint(Vector3); // 点（受缩放影响）
this.transform.TransformDirection(Vector3); // 方向（不受缩放影响）
this.transform.TransformVector(Vector3); // 方向（受缩放影响）

// 世界坐标 → 本地坐标
this.transform.InverseTransformPoint(Vector3); // 点（受缩放影响）
this.transform.InverseTransformDirection(Vector3);// 方向（受缩放影响）
this.transform.InverseTransformVector(Vector3)// 方向（不受缩放影响）
```

---

### 练习

> 1. 一个物体 A，不管它在什么位置，写一个方法，只要执行这个方法就可以在它的左前方(-1,0,1)处创建一个空物体

```csharp
[ContextMenu("在左前方创建一个空物体")]
void NewObject()
{
    GameObject obj = new GameObject();
    obj.transform.position = transform.TransformPoint(new Vector3(-1, 0, 1));
}
```

> 2. 一个物体 A，不管它在什么位置，写一个方法，在它的前方创建出3个球体，位置分别是(0,0,1)、(0,0,2)、(0,0,3)

```csharp
[ContextMenu("在前方创建3个球体")]
public void New3Object()
{
    for (int i = 1; i <= 3; i++)
    {
        GameObject obj = GameObject.CreatePrimitive(PrimitiveType.Sphere);
        obj.transform.position = transform.TransformPoint(Vector3.forward * i);
    }
}
```

---

## 我的踩坑记录

- 移动不乘 `Time.deltaTime` 会导致帧率差异
- 旋转角度取值范围 0~360，判断时注意边界

---

*最后更新：*
