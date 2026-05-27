# 🎯 12 GameObject

**所属模块**：[[00 Unity入门阶段总览]]
**关联**：[[02 类与对象]] | [[11 MonoBehavior 重要内容]]
**查阅次数**：3

---

## 核心理解

> **GameObject 是 Unity 场景中的最小单位。**
> 场景中所有的东西（摄像机、灯光、角色、UI）本质上都是 GameObject。

---

## 成员变量

```csharp
GameObject.name // 名称
GameObject.activeSelf // 是否激活（只读，自身激活状态）
GameObject.isStatic // 是否静态
GameObject.layer // 层级（0~31）
GameObject.tag // 标签
GameObject.transform // Transform 组件
```

---

## 静态方法

**注意：如果继承了 MonoBehavior，可以不用写 GameObject**

---

### 创建对象

```csharp
//创建基本几何体 CreatePrimitive
//返回值 GameObject
GameObject.CreatePrimitive(PrimitiveType.Cube);
GameObject.CreatePrimitive(PrimitiveType.Sphere);
```

---

### 查找对象

**注意：**
- 查找对象无法找到失活的对象，只能找到激活的对象
- 如果场景中有多个满足条件对象对象，无法准确查找对象
- 找到返回对象 没有找到返回空

```csharp
//查找单个对象  
//这个查找效率比较低下 因为他会在场景中的所有对象去查找
GameObject.Find("对象名")  //通过对象名查找 Find 

GameObject.FindWithTag("标签") //通过标签查找 FindWithTag 返回第一个
GameObject.FindGameObjectWithTag("标签") //  这个方法和上面一模一样 只是名字不一样

//查找多个对象 FindGameObjectsWithTag
GameObject.FindGameObjectsWithTag("标签")//返回的是数组

//其他方法
GameObject.FindObjectOfType<脚本类名>(); //找到场景中挂载的某个脚本的对象
```

---

### 实例化（克隆）与销毁对象

**实例化前置：**
- 先声明一个GameObjct成员变量 然后将对象从Unity中拖进来关联 一般都是克隆预设体

```csharp
// 实例化（Instantiate）
GameObject.Instantiate(gameObject);
// 简写（在 MonoBehavior 中）
Instantiate(gameObject);
Instantiate(gameObject, position, rotation);

// 销毁（Destroy） 不仅可以删除对象 还可以删除脚本
GameObject.Destroy(gameObject); // 当前帧结束后销毁
GameObject.Destroy(gameObject, 延迟秒数); // 延迟销毁
GameObject.DestroyImmediate(gameObject);  // 立即销毁（慎用）

// 过场景不移除对象（DontDestroyOnLoad）
// 默认情况下，切换场景时场景中对象都会被自动移除掉
// 如果希望某个对象过场景不被移除，就传谁（一般传依附的 GameObject 对象）
GameObject.DontDestroyOnLoad(gameObject);
```

---

## 成员方法

---

### 重要

```csharp
//创建空对象
new GameObject();
new GameObject("我创建的脚本");
new GameObject("我创建的脚本", typeof(脚本类型), ...);

//为对象添加脚本
//同样有多种重载 泛型最常用 不需要类型转换
Test t = gameObject.AddComponent<Test>();//为gameObject对象 添加 Test 脚本

//得到脚本 和继承Mono的类得到脚本的方法一模一样 [[11 MonoBehavior 重要内容#^3dcffa]]
 
//标签比较 CompareTag 
if (this.gameObject.CompareTag("Player")) //返回值bool
{
	//逻辑
}
if (this.gameObject.tag == "Player")
{
	//逻辑
}

//设置失活激活
gameObject.SetActive(false);//失活
gameObject.SetActive(true);//激活
```

^bcb49e

---

### 次要

```csharp
//通过广播或者发送消息的形式 让别人或者自己 执行某些行为方法   
//通知自己 执行什么行为       
//会去找到 自己身上所有的脚本 有这个名字的函数去执行

//命令自己 去执行TestFun这个函数 会在自己身上挂载的所有脚本中去找这个名字的函数
gameObject.SendMessage("TestFun")  
gameObject.SendMessage("TestFun", 参数)
    
//广播行为 让自己和自己的子对象执行 TestFun这个函数
gameObject.BroadcastMessage("TestFun", 参数)
    
//向父对象和自己发送消息并执行 TestFun这个函数
gameObject.SendMessageUpwards("TestFun", 参数)
```

---

## 练习

> 1. 一个空物体上挂了一个脚本，游戏运行时该脚本可以实例化出之前的坦克预设体

```csharp
public class A : MonoBehaviour
{
    public GameObject tank;  // 在 Unity 中关联坦克预设体

    void Start()
    {
        if (tank != null)
            Instantiate(tank);
    }
}
```

> 2. 一个脚本 A 挂在 A 对象上，脚本 B 挂在 B 对象上，实现在 A 脚本的 Start 函数中将 B 对象上的 B 脚本失活（用 GameObject 相关知识做）

```csharp
public class A : MonoBehaviour
{
    // 方法1：直接关联
    public GameObject bObj;  // 在 Unity 中关联 B 对象

    void Start()
    {
        B1 b1 = bObj.GetComponent<B1>();
        if (b1 != null)
            b1.enabled = false;
    }

    // 方法2：代码查找
    void Start2()
    {
        GameObject b = GameObject.Find("B");
        B1 b1 = b.GetComponent<B1>();
        if (b1 != null)
            b1.enabled = false;
    }
}
```

> 3. 一个对象 A 和一个对象 B，在 A 上挂个脚本，通过这个脚本可以让 B 对象改名、失活、延迟删除、即删除，可以在 Inspector 窗口中设置让 B 实现不同效果

```csharp
public enum E_Do
{
    changeName,
    ActiveFalse,
    delayDes,
    des,
}

public class A : MonoBehaviour
{
    public GameObject obj;  // 在 Unity 中关联 B 对象
    public E_Do       type;

    void Start()
    {
        switch (type)
        {
            case E_Do.changeName:
                obj.name = "B对象改名";
                break;
            case E_Do.ActiveFalse:
                obj.SetActive(false);
                break;
            case E_Do.delayDes:
                Destroy(obj, 5);
                break;
            case E_Do.des:
                DestroyImmediate(obj);
                break;
        }
    }
}
```

---

## 我的踩坑记录

- `Find` 在场景中有同名对象时无法准确查找，建议用标签或直接关联

---

*最后更新：*
