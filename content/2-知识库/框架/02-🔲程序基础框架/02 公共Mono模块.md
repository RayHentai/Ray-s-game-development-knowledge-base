# 02 公共Mono模块

**所属模块**：[[00 程序基础框架 总览]]
**关联**：[[13 事件]] | [[09 脚本生命周期]] | [[07 协同程序]]
**查阅次数**：0

---

## 核心理解

- 公共Mono模块的主要作用：让不继承MonoBehaviour的脚本也能
	1. 利用帧更新或定时更新处理逻辑
	2. 利用协同程序处理逻辑
	3. 可以统一执行管理帧更新或定时更新相关逻辑

- 公共Mono模块的基本原理
	1. 通过事件或委托管理不继承MonoBehaviour脚本的相关更新函数
	2. 提供协同程序开启或关闭的方法


---

## 主要作用

**Unity游戏开发当中，继承MonoBehaviour的类，可以使用生命周期函数，可以开启协同程序**
- 可以利用生命周期函数中的Update、FixedUpdate、LateUpdate等函数进行帧更新或定时更新，用来处理游戏逻辑
- 可以利用协同程序分时分步的处理游戏逻辑，比如异步加载，复杂逻辑分步等

**但是对于没有继承MonoBehaviour的脚本，无法使用这些内容来处理逻辑**
在不进行任何处理的情况下，无法在不继承MonoBehaviour的脚本中进行帧更新或者定时更新逻辑，也无法利用协同程序分时分步执行逻辑

**因此公共Mono模块的主要作用是：让不继承MonoBehaviour的脚本也能**
1. 利用帧更新或定时更新处理逻辑
2. 利用协同程序处理逻辑

**除了这两个主要作用**
由于Unity当中过多脚本中的过多帧更新或定时更新函数会对性能有一定的影响
在满足主要作用的同时，还可以对它们进行集中化管理
减少Unity中多脚本中帧更新或定时更新函数的数量，从而来提升一定的性能

---

## 基本原理

**实现一个继承继承MonoBehaviour单例模式基类的公共Mono管理器脚本**
在其中
1. 通过事件或委托管理不继承MonoBehaviour脚本的相关更新函数
2. 提供协同程序开启或关闭的方法

**从而达到目的，让不继承MonoBehaviour的脚本也能**
1. 利用帧更新或定时更新处理逻辑
2. 利用协同程序处理逻辑
3. 可以统一执行管理帧更新或定时更新相关逻辑

---

## 基本实现

1. 创建MonoMgr继承 自动挂载式的继承MonoBehaviour的单例模式基类
2. 实现Update、FixedUpdate、LateUpdate生命周期函数
3. 声明对应事件或委托用于存储外部函数，并提供添加移除方法，从而达到让不继承MonoBehaviour的脚本可以执行帧更新或定时更新的目的
4. 声明协同程序开启关闭函数，从而达到让不继承MonoBehaviour的脚本可以执行协同程序的目的

```csharp
public class MonoMgr : SingletonAutoMono<MonoMgr>
{
    //监听三种帧更新函数的委托事件
    public event UnityAction updateEvent;
    public event UnityAction fixedUpdateEvent;
    public event UnityAction lateUpdateEvent;
    /// <summary>
    /// 添加帧更新的监听函数
    /// </summary>
    public void AddUpdateListener(UnityAction updateFun)
    {
        updateEvent += updateFun;
    }
    /// <summary>
    /// 移除帧更新的监听函数
    /// </summary>
    public void RemoveUpdateListener(UnityAction updateFun)
    {
        updateEvent -= updateFun;
    }
    /// <summary>
    /// 添加物理帧更新的监听函数
    /// </summary>
    public void AddFixedUpdateListener(UnityAction fixeUpdateFun)
    {
        updateEvent += fixeUpdateFun;
    }
    /// <summary>
    /// 移除物理帧更新的监听函数
    /// </summary>
    public void RemoveFixedUpdateListener(UnityAction fixeUpdateFun)
    {
        updateEvent -= fixeUpdateFun;
    }
    /// <summary>
    /// 增加延迟帧更新的监听函数
    /// </summary>
    public void AddLateUpdateListener(UnityAction lateUpdateFun)
    {
        updateEvent += lateUpdateFun;
    }
    /// <summary>
    /// 移除延迟帧更新的监听函数
    /// </summary>
    public void RemoveLateUpdateListener(UnityAction lateUpdateFun)
    {
        updateEvent -= lateUpdateFun;
    }

    private void Update()
    {
        updateEvent?.Invoke();
    }
    private void FixedUpdate()
    {
        fixedUpdateEvent?.Invoke();
    }
    private void LateUpdate()
    {
        lateUpdateEvent?.Invoke();
    }
}
```

**测试**

```csharp
//不继承MonoBehaviour的脚本
//利用帧更新或定时更新处理逻辑
//利用协同程序处理逻辑
public class Test_MonoMgr : BaseManager<Test_MonoMgr>
{
    private Test_MonoMgr() { }
    public void ICanUpdate()
    {
        MonoMgr.Instance.AddUpdateListener(MyUpdate);
    }
    public void ICanStopUpdate()
    {
        MonoMgr.Instance.RemoveUpdateListener(MyUpdate);
    }
    public void MyUpdate()
    {
        Debug.Log("我可以帧更新");
    }

    public void ICanStartCoroutine()
    {
        MonoMgr.Instance.StartCoroutine(Test());
    }
    IEnumerator Test()
    {
        yield return new WaitForSeconds(3f);
        Debug.Log("不继承Mono我也可以启动协程");
    }
}

public class Main : MonoBehaviour
{
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E))
        {
            Test_MonoMgr.Instance.ICanUpdate();
            Test_MonoMgr.Instance.ICanStartCoroutine();
        }
        if (Input.GetKeyUp(KeyCode.E))
            Test_MonoMgr.Instance.ICanStopUpdate();
    }
}

//继承MonoBehaviour的脚本
//可以统一执行管理帧更新或定时更新相关逻辑
public class Test : MonoBehaviour
{
	Start()
	{
		MonoMgr.Instance.AddUpdateListener(MyUpdate);
	}
	public void MyUpdate()
    {
        Debug.Log("通过Mono管理器来进行帧更新");
    }
}
```

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- 场景一：
- 场景二：
- 反例（不该用的时候）：

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

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
