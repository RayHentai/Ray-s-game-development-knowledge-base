# 10 Resources 异步加载

**所属模块**：[[00 Unity 基础阶段总览]]
**关联**：[[12 委托]] | [[13 事件]] | [[18 多线程]] | [[07 协同程序]] | [[08 Unity中特殊文件夹]] | [[09 Resources 同步加载]]
**查阅次数**：0

---

## 核心理解

> 在内部新开一个线程进行资源加载，不会造成主线程卡顿

- 如果加载过大的资源可能会造成程序卡顿
- 卡顿的原因就是从硬盘上把数据读取到内存中，是需要进行计算的
- 越大的资源耗时越长，就会造成掉帧卡顿

---

## 语法 / 用法

**注意：**
- 异步加载不能马上得到加载的资源，至少要等一帧
- 加载完毕后会把加载出来的资源对象放在公共内存区供主线程使用，所以至少要等一帧

```csharp
//1 通过异步加载中的完成事件，监听使用加载的资源
public Texture tex;

ResourceRequest rq = Resources.LoadAsync<Texture>("路径/文件名");//开一个线程进行资源下载
rq.completed += LoadOver;//进行一个资源下载结束的事件函数监听 委托传入的函数必须跟事件类型一样

rq.completed += (value) => { tex = (rq as ResourceRequest).asset as Texture; }//一步到位写法
private void LoadOver(AsyncOperation rq) //completed 的事件类型是 AsyncOperation
{
	Print("加载结束")
	//AsyncOperation 是 ResourceRequest 的父类 也是一个基类 函数是用基类去传对象 所以要转换成 ResourceRequest 才能点出 asset 资源对象
	tex = (rq as ResourceRequest).asset as Texture;//asset 是资源对象 加载完毕后就能得到他
}
private void OnGUI()
{
	if (tex != null) //异步加载不是马上就能加载完毕的 所以要判空保护
		GUI.DrawTexture(new Rect(0, 0, 100, 100), tex);
}

//2 通过协程使用加载的资源
StartCoroutine(Load());

IEnumerator Load() 
{
	ResourceRequest rq = Resources.LoadAsync<Texture>("路径/文件名");//第一次执行
	
	//第一种处理方式
	yield return rq;//Unity 知道 这个返回值 代表在异步加载资源 会自己判断 该资源是否加载完毕 加载完毕才会执行后面的代码
	
	//第二种处理方法
	while (!rq.isDone) //判断是否加载结束
		Print(rq.priority); //加载进度 0 ~ 1 如果资源很小 不会特别准确 过渡也不明显 
		yield return null;//每一帧判断一次
	
	tex = rq.Asset as Texture;
}
```

**异同：**

| 对比项  | 事件监听                    | 协程                          |
| ---- | ----------------------- | --------------------------- |
| 优点   | 写法简单                    | 可以在协程中处理复杂逻辑，比如加载多个资源、进度条更新 |
| 缺点   | 只能在资源加载结束后进行处理，适合加载一个资源 | 写法复杂                        |
| 加载形式 | 线性加载                    | 并行加载                        |

^bceb19

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- 事件监听：加载一个资源
- 协程：加载多个资源，有特殊功能需求（进度条）

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 使用异步加载的资源前需要判空
- 

---

## 练习

> 1. 请写一个简单的资源管理器，提供统一的方法给外部用于资源异步加载，外部可以传入委托用于当资源加载结束时使用资源

```csharp
public class Resources_Mgr
{
    private static Resources_Mgr instance = new Resources_Mgr();
    public static Resources_Mgr Instance => instance;

    public void Load<T>(string name, UnityAction<T> callback) where T : Object //[[拓展知识#^3e737c]]
    {
        ResourceRequest rq = Resources.LoadAsync<T>(name);
        rq.completed += (a) => { callback((a as ResourceRequest).asset as T); };
    }

    public IEnumerator LoadC<T>(string name, UnityAction<T> callback) where T : Object
    {
        ResourceRequest rq = Resources.LoadAsync<T>(name);
        yield return rq;
        T result = rq.asset as T;
        callback?.Invoke(result);
    }
}

public class Resources_Load : MonoBehaviour
{
    public Texture tex;
    void Start()
    {
        Resources_Mgr.Instance.Load<Texture>("Tex/Test", (obj) => { tex = obj; });//方法1 委托加载
        StartCoroutine(Resources_Mgr.Instance.LoadC<Texture>("Tex/Test", (obj) => { tex = obj; }));//方法2 协程加载

    }
    private void OnGUI()
    {
        if (tex != null)
            GUI.DrawTexture(new Rect(0, 0, 100, 100), tex);
    }
}
```

^a7082c

---

## API 速查
- Resources.LoadAsync （方法 异步加载资源） 存在泛型重载
- ResourceRequest.completed （成员委托 加载完成监听）
- ResourceRequest.isDone （成员属性 是否加载结束）
- ResourceRequest.priority （成员属性 加载进度）

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
