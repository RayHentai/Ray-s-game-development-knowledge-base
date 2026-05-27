# 🧩 11 MonoBehavior 重要内容

**所属模块**：[[00 Unity入门阶段总览]]
**关联**：[[08 脚本基础规则]] | [[09 脚本生命周期]] | [[12 GameObject]]
**查阅次数**：1

---

## 重要成员

> 在继承了 MonoBehavior 的脚本中：

| 写法                      | 含义                                |
| ----------------------- | --------------------------------- |
| `this`                  | 脚本对象本身                            |
| `this.gameObject`       | 脚本对象依附的 GameObject 对象             |
| `this.transform`        | 脚本对象依附的 GameObject 的 Transform 组件 |
| `gameObject`            | 同 `this.gameObject`（可省略 this）     |
| `transform`             | 同 `this.transform`（可省略 this）      |
| `transform.position`    | 脚本对象依附的 GameObject 的 位置 信息        |
| `transform.eulerAngles` | 脚本对象依附的 GameObject 的 角度 信息        |
| `transform.lossyScale`  | 脚本对象依附的 GameObject 的 缩放 信息        |


**获取其他GameObject**

```csharp
public class Test ： MonoBehaviour
{
	public Test otherObject;
	//拖拽关联想要得到信息的对象 [[Object 拖拽关联.png]]
}
```

---

## 重要方法

### 得到挂载的脚本

**注意：**
- 如果挂了多个脚本 获取单个脚本是不能确定获取的是哪一个的
- 寻找子类、父类的脚本时，默认也会找自己身上是否挂载该脚本
- 如果获取失败 就是没有对应的脚本 会默认返回 `null`

```csharp
//this. 都是可以省略的
//有一个对象 挂载了 Test 和 Test_1 脚本 有一个子对象 挂载了 Test_2
public class Test ： MonoBehaviour
{
	void Start
	{
		//得到自己挂载的单个脚本 GetComponent 
		//GetComponent 得到的是一个基类 所以需要进行类型转换
		Test_1 t = this.GetComponent("Test_1") as Test_1;//根据脚本名获取 参数为脚本名
		//同样需要转换类型 
		Test_1 t2 = this.GetComponent(typeof(Test_1)) as Test_1;//根据Type获取 参数为脚本Type
		
		//无需转换类型 最推荐
		Test_1 t3 = this.GetComponent<Test_1>();//根据泛型获取
		
		//得到自己挂载的多个脚本 GetComponents
		//同样有多种重载 最常用还是泛型
		Test[] array = this.GetComponents<Test>();//用数组直接存
		List<Test> list;
		this.GetComponents<Test>(list);//用list存
		
		//得到子对象挂载的单个脚本 GetComponentInChildren
		//默认也会找自己身上是否挂载该脚本
		//参数 true => 子对象失活了也找 false 不找
		Test_2 t4 = this.GetComponentInChildren<子对象脚本类名>(bool);
		
		//得到子对象挂载的多个脚本
		Test_2[] array2 = this.GetComponentsInChildren<子对象脚本类名>(bool);//直接用数组存
		List<Test_2> list2;
		this.GetComponentsInChildren<子对象脚本类名>(bool, list2);//用List存
	}
}

public class Test_2 ： MonoBehaviour
{
	void Start
	{
		//得到父对象挂载的单个脚本 GetComponentInParent
		Test t5 = this.GetComponentInParent<Test>()
		
		//得到父对象挂载的多个脚本 GetComponentsInParents
		Test[] array3 = this.GetComponentsInParent<Test>();
		this.GetComponents<Test>(list);
		
		//尝试获取脚本TryGetComponent
		//返回值是bool值 找到了返回true
		//提供了一个更安全的获取脚本的方法
		Test t6;
		if (this.TryGetComponent<Test>(out t6))
		{
			//处理逻辑
		}
	}
}
```

^3dcffa

---

## 控制脚本激活/失活

```csharp
this.enabled = false;//失活
this.enabled = true;//激活
```

^c8e3b2

---

## 练习

> 1. 请说出一个继承了 MonoBehavior 的脚本中，this、this.gameObject、this.transform 分别代表什么？

```csharp
this → 脚本对象本身
this.gameObject → 脚本对象依附的 GameObject 对象
this.transform  → 脚本对象依附的 GameObject 对象的位置信息（Transform 组件）
```

> 2. 一个脚本 A 一个脚本 B，他们都挂在一个 GameObject 上，实现在 A 中的 Start 函数中让 B 脚本失活

```csharp
public class A : MonoBehaviour
{
    void Start()
    {
        B b = this.GetComponent<B>();
        if (b != null)
            b.enabled = false;
    }
}
```

> 3. 一个脚本 A 挂在 A 对象上，脚本 B 挂在 B 对象上，实现在 A 脚本的 Start 函数中将 B 对象上的 B 脚本失活

```csharp
public class A : MonoBehaviour
{
    public B b;  // 在 Unity 中关联 B 脚本

    void Start()
    {
        if (b != null)
            b.enabled = false;
    }
}
```

---

## 我的踩坑记录

- `enabled` 是控制脚本激活/失活，`gameObject.SetActive(false)` 是控制整个对象激活/失活
- 代码要写在生命周期函数内 否则会报错

---

*最后更新：*
