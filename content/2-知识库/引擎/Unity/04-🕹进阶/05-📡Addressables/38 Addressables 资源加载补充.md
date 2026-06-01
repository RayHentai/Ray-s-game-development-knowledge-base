# 38 Addressables 资源加载补充

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 分部加载资源

---

### Addressables 加载资源的执行步骤

1.查找指定键的资源位置
2.收集依赖项列表
3.下载所需的所有远程AB包
4.将AB包加载到内存中
5.设置Result资源对象的值
6.更新Status状态变量参数并且调用完成事件Completed

如果加载成功Status状态为成功，并且可以从Result中得到内容

如果加载失败，除了Status状态为失败外
启用了 Log Runtime Exceptions选项 会在Console窗口打印信息

---

### 根据资源定位信息 加载资源

**拆开加载的步骤分部加载资源的原因**
**1.资源信息当中提供了一些额外信息**
  PrimaryKey：资源主键（资源名）
  InternalId：资源内部ID（资源路径）
  ResourceType：资源类型（Type可以获取资源类型名）
  
  可以利用这些信息处理一些特殊需求
  比如加载多个不同类型资源时 可以通过他们进行判断再分别进行处理

**2.根据资源定位信息加载资源并不会加大加载开销**
  只是分部完成加载了而已

---

#### 根据名字或者标签获取 资源定位信息

```csharp
AsyncOperationHandle<IList<IResourceLocation>> handle = Addressables.LoadResourceLocationsAsync("Cube", typeof(GameObject));
handle.Completed += (obj) =>
{
    if(obj.Status == AsyncOperationStatus.Succeeded)
    {
        foreach (var item in obj.Result)
        {
            //我们可以利用定位信息 再去加载资源
            //print(item.PrimaryKey); //资源的名字
            Addressables.LoadAssetAsync<GameObject>(item).Completed += (obj) =>
            {
                Instantiate(obj.Result);
            };
        }
    }
    else
    {
        Addressables.Release(handle);
    }
};
```

---

#### 根据名字标签组合信息获取 资源定位信息

```csharp
//参数一：资源名和标签名的组合
//参数二：合并模式
//参数三：资源类型
AsyncOperationHandle<IList<IResourceLocation>> handle2 = Addressables.LoadResourceLocationsAsync(new List<string>() { "Cube", "Sphere", "SD" }, Addressables.MergeMode.Union, typeof(Object));
handle2.Completed += (obj) => { 
    if(obj.Status == AsyncOperationStatus.Succeeded)
    {
        //资源定位信息加载成功
        foreach (var item in obj.Result)
        {
            //使用定位信息来加载资源
            //可以利用定位信息 再去加载资源
            print(item.PrimaryKey); //资源主键（资源名）
            print(item.InternalId); //资源内部ID（资源路径）
            print(item.ResourceType.Name);//资源类型（Type可以获取资源类型名）

            Addressables.LoadAssetAsync<Object>(item).Completed += (obj) =>
            {
                //加载资源
            };
        }
    }
    else
    {
        Addressables.Release(handle);
    }
};
```

---

## 三种异步加载资源的方法

**1. 事件监听**

```csharp
AsyncOperationHandle<GameObject> handle;
handle = Addressables.LoadAssetAsync<GameObject>("Cube");
//通过事件监听的方式 结束时使用资源
handle.Completed += (obj) =>
{
    if (handle.Status == AsyncOperationStatus.Succeeded)
    {
        print("事件创建对象");
        Instantiate(obj.Result);
    }
};
```

**2. 协同程序**

```csharp
AsyncOperationHandle<GameObject> handle;

StartCoroutine(LoadAsset());

IEnumerator LoadAsset()
{
    handle = Addressables.LoadAssetAsync<GameObject>("Cube");
    //一定是没有加载成功 再去 yield return
    if(!handle.IsDone)
        yield return handle;
    //加载成功 那么久可以使用了
    if (handle.Status == AsyncOperationStatus.Succeeded)
    {
        print("协同程序创建对象");
        Instantiate(handle.Result);
    }
    else //加载失败 释放
        Addressables.Release(handle);
}
```

**3. 异步函数（async和await）**

**注意：WebGL平台不支持异步函数语法**

```csharp
AsyncOperationHandle<GameObject> handle;

Load();
Load2();

async void Load()
{
    handle = Addressables.LoadAssetAsync<GameObject>("Cube");
    //单任务等待
    await handle.Task;
    print("异步函数的形式加载的资源");
    Instantiate(handle.Result);
}

async void Load2()
{
    handle = Addressables.LoadAssetAsync<GameObject>("Cube");
    AsyncOperationHandle<GameObject> handle2 = Addressables.LoadAssetAsync<GameObject>("Sphere");
    //多任务等待
    await Task.WhenAll(handle.Task, handle2.Task);
    print("异步函数的形式加载的资源");
    Instantiate(handle.Result);
    Instantiate(handle2.Result);
}
```


---

## 加载资源时的一些特殊处理

**获取加载进度（协同程序）**

```csharp
StartCoroutine(LoadAsset());

IEnumerator LoadAsset()
{
    AsyncOperationHandle<GameObject> handle = Addressables.LoadAssetAsync<GameObject>("Cube");
    //注意：如果该资源相关的AB包 已经加载过了 那么 只会打印0
    while (!handle.IsDone)
    {
        DownloadStatus info = handle.GetDownloadStatus();
        //进度
        print(info.Percent);
        //字节加载进度 代表 AB包 加载了多少
        //当前下载了多少内容 /  总体有多少内容 单位是字节数
        print(info.DownloadedBytes + "/" + info.TotalBytes);
        yield return 0;
    }
    if (handle.Status == AsyncOperationStatus.Succeeded)
        Instantiate(handle.Result);
    else
        Addressables.Release(handle);
}
```

**无类型句柄转换**

```csharp
AsyncOperationHandle<Texture2D> handle = Addressables.LoadAssetAsync<Texture2D>("Cube");
AsyncOperationHandle temp = handle;

//这样写也可以 等同于 AsyncOperationHandle temp = handle
AsyncOperationHandle handle2 = Addressables.LoadAssetAsync<Texture2D>("Cube"); 

//此时handle是有类型的泛型对象 temp 是无类型的句柄
//可以把无类型句柄 转换为 有类型的泛型对象
handle = temp.Convert<Texture2D>();
//可以应用到资源加载管理器中 字典中就不用通过一个基接口装子对象了
```

**强制同步加载资源**

**注意：**
Unity2020.1版本或者之前，执行该句代码不仅会等待该资源
他会等待所有没有加载完成的异步加载加载完后才会继续往下执行
Unity2020.2版本或以上版本，在加载已经下载的资源时性能影响会好一些
所以，总体来说不建议使用这种方式加载资源

```csharp
AsyncOperationHandle<Texture2D> handle = Addressables.LoadAssetAsync<Texture2D>("Cube");
//如果执行了WaitForCompletion 那么会卡主主线程 一定要当资源加载结束后
//才会继续往下执行
print("1");
handle.WaitForCompletion();
print("2");
print(handle.Result.name);
```

---

### 练习

> 1. 修改之前练习题写的可寻址管理器，让Clear中可以清除所有字典中的对象

**潜在问题**
此时的资源管理器通过自己管理异步加载的返回句柄会让系统自带的引用计数功能不起作用
因为不停的在复用一个句柄，加载同一个资源该资源的引用计数永远是1

```csharp
/// <summary>
/// Addressables可寻址资源加载管理器
/// </summary>
public class AddressablesMgr : BaseManager<AddressablesMgr>
{
    private AddressablesMgr() { }
    //用于存储已加载资源的容器 里氏替换原则用基接口装子类资源
    public Dictionary<string, AsyncOperationHandle> resDic = new Dictionary<string, AsyncOperationHandle>();
    /// <summary>
    /// 异步加载资源
    /// </summary>
    /// <typeparam name="T">资源类型</typeparam>
    /// <param name="name">资源名</param>
    /// <param name="callBack">回调函数</param>
    public void LoadAssetAsync<T>(string name, Action<AsyncOperationHandle<T>> callBack)
    {
        //资源名 或 资源标签 _ 资源类型
        //Cube_GameObject
        string keyName = $"{name}_{typeof(T).Name}";
        AsyncOperationHandle<T> handle;
        if (resDic.ContainsKey(keyName)) //如果已经加载过资源
        {
            handle = resDic[keyName].Convert<T>();//从字典中取出资源
            if (handle.IsDone) //是否加载结束
                callBack(handle);
            else //没有加载结束叠加回调函数
                handle.Completed += callBack;
            return;
        }
        //如果没有加载过资源
        //直接进行异步加载 并记录
        handle = Addressables.LoadAssetAsync<T>(name);
        handle.Completed += (obj) =>
        {
            if (obj.Status == AsyncOperationStatus.Succeeded)
                callBack(obj);
            else
            {
                Debug.LogWarning($"ID为{keyName}的资源加载失败");
                if (resDic.ContainsKey(keyName))
                    resDic.Remove(keyName);//移除容器中的该资源
            }
        };
        resDic.Add(keyName, handle);
    }
    /// <summary>
    /// 异步加载多个资源 或指定资源
    /// </summary>
    /// <typeparam name="T">资源类型</typeparam>
    /// <param name="mode">合并模式</param>
    /// <param name="callBack">回调函数</param>
    /// <param name="keys">资源、标签名</param>
    public void LoadAssetAsync<T>(Addressables.MergeMode mode, Action<T> callBack, params string[] keys)
    {
        //1 构建一个keyName
        //资源名 或 资源标签 _ 资源标签1 _ 资源标签2 _ ... 资源类型
        //Cube_HD_Red_GameObject
        List<string> list = new List<string>(keys);
        string keyName = "";
        foreach (string key in list)
            keyName += $"{key}_";
        keyName += typeof(T).Name;
        AsyncOperationHandle<IList<T>> handle;
        if (resDic.ContainsKey(keyName))
        {
            handle = resDic[keyName].Convert<IList<T>>();
            if (handle.IsDone) //如果加载完毕
                foreach (T item in handle.Result)
                    callBack(item);
            else //如果没有加载完毕 等待加载完毕后执行
                handle.Completed += (obj) =>
                {
                    if (obj.Status == AsyncOperationStatus.Succeeded) //成功加载才执行
                        foreach (T item in obj.Result)
                            callBack(item);
                };
        }
        else
        {
            handle = Addressables.LoadAssetsAsync<T>(list, callBack, mode);
            handle.Completed += (obj) =>
            {
                if (obj.Status == AsyncOperationStatus.Failed)
                {
                    Debug.LogWarning($"ID为{keyName}的资源加载失败");
                    if (resDic.ContainsKey(keyName))
                        resDic.Remove(keyName);
                }
            };
            resDic.Add(keyName, handle);
        }
    }
    public void LoadAssetAsync<T>(Addressables.MergeMode mode, Action<AsyncOperationHandle<IList<T>>> callBack, params string[] keys)
    {
        //回调函数 传递出去的参数为异步加载的返回值
        //用于在外部处理handle的重载
    }
    /// <summary>
    /// 释放资源
    /// </summary>
    /// <typeparam name="T">资源类型</typeparam>
    /// <param name="name">资源名</param>
    public void Release<T>(string name)
    {
        string keyName = $"{name}_{typeof(T).Name}";
        if (resDic.ContainsKey(keyName))
        {
            AsyncOperationHandle<T> handle = resDic[keyName].Convert<T>();//从字典中取出资源
            Addressables.Release(handle);//卸载资源
            resDic.Remove(keyName);//移除容器中的该资源
        }
    }
    /// <summary>
    /// 释放多个资源 或指定资源
    /// </summary>
    /// <typeparam name="T">资源类型</typeparam>
    /// <param name="keys">资源、标签名</param>
    public void Release<T>(params string[] keys)
    {
        List<string> list = new List<string>(keys);
        string keyName = "";
        foreach (string key in list)
            keyName += $"{key}_";
        keyName += typeof(T).Name;
        if (resDic.ContainsKey(keyName)) //如果存在资源 
        {
            AsyncOperationHandle<IList<T>> handle = resDic[keyName].Convert<IList<T>>();
            Addressables.Release(handle);
            resDic.Remove(keyName);
        }
    }
    /// <summary>
    /// 粗暴的清除方法 
    /// 建议保证后面不再使用加载过的资源时执行
    /// </summary>
    public void Clear()
    {
        foreach (var item in resDic.Values)
            Addressables.Release(item);
        resDic.Clear();
        AssetBundle.UnloadAllAssetBundles(true);
        Resources.UnloadUnusedAssets();
        GC.Collect();
    }
}
```

---

## 自定义更新目录和预加载包

**目录的作用：**
目录文件的本质是Json文件和一个Hash文件

**1. Json文件中记录的是：**
1. 加载AB包、图集、资源、场景、实例化对象所用的脚本（会通过反射去加载他们来使用）
2. AB包中所有资源类型对应的类（会通过反射去加载他们来使用）
3. AB包对应路径
4. 资源的path名
5. 等等

**6. Hash文件中记录的是：**
目录文件对应hash码（每一个文件都有一个唯一码，用来判断文件是否变化）

更新时本地的文件hash码会和远端目录的hash码进行对比
如果发现不一样就会更新目录文件

当使用远端发布内容时，在资源服务器也会有一个目录文件
Addressables会在运行时自动管理目录
如果远端目录发生变化了(他会通过hash文件里面存储的数据判断是否是新目录)
它会自动下载新版本并将其加载到内存中

**更新目录和预加载包的时机**
- 一般会在刚进入游戏时或者切换场景时显示一个Loading界面，可以在此时提前加载包，这样之后在使用资源就不会出现明显的异步加载延迟感
- 目录更新，一般都会放在进入游戏开始游戏之前执行

---

### 手动更新目录

**注意：如果要手动更新目录 建议在设置勾选手动更新目录**
![[勾选手动更新目录 图示.png]]

```csharp
//1 自动检查所有目录是否有更新，并更新目录API
Addressables.UpdateCatalogs().Completed += (obj) =>
{
    Addressables.Release(obj);
};

//2 获取目录列表，再更新目录
//参数 bool 就是加载结束后 会不会自动释放异步加载的句柄
Addressables.CheckForCatalogUpdates(true).Completed += (obj) =>
{
    //如果列表里面的内容大于0 证明有可以更新的目录
    if(obj.Result.Count > 0)
    {
        //根据目录列表更新目录
        Addressables.UpdateCatalogs(obj.Result, true).Completed += (handle) =>
        {
            //如果更新完毕 记得释放资源 
            //如果参数都填入true 就不用自己手动释放了
            //Addressables.Release(handle);
            //Addressables.Release(obj);
        };
    }
};
```

---

### 预加载包

**建议通过协程来加载**

```csharp
StartCoroutine(LoadAsset());

IEnumerator LoadAsset()
{
    //1 首先获取下载包的大小
    //可以传资源名、标签名、或者两者的组合
    AsyncOperationHandle<long> handleSize = Addressables.GetDownloadSizeAsync(new List<string>() { "Cube", "Sphere", "SD" });
    yield return handleSize;
    //2 预加载
    if(handleSize.Result > 0)
    {
        //这样就可以异步加载 所有依赖的AB包相关内容了
        AsyncOperationHandle handle = Addressables.DownloadDependenciesAsync(new List<string>() { "Cube", "Sphere", "SD" }, Addressables.MergeMode.Union);
        while(!handle.IsDone)
        {
            //3.加载进度
            DownloadStatus info = handle.GetDownloadStatus();
            print(info.Percent);
            print(info.DownloadedBytes + "/" + info.TotalBytes);
            yield return 0;
        }
        Addressables.Release(handle);
    }
}
```

---

## 引用计数

当通过加载使用可寻址资源时，Addressables会在内部帮助我们进行引用计数
使用资源时，引用计数+1
释放资源时，引用计数-1
当可寻址资源的引用为0时，就可以卸载它了

为了避免内存泄露（不需要使用的内容残留在内存中）
要保证加载资源和卸载资源是配对使用的

**注意：释放的资源不一定立即从内存中卸载**
在卸载资源所属的AB包之前，不会释放资源使用的内存
(比如自己所在的AB包 被别人使用时，这时AB包不会被卸载，所以自己还在内存中)
可以使用Resources.UnloadUnusedAssets卸载资源（建议在切换场景时调用）

AB包也有自己的引用计数（Addressables把它也视为可寻址资源）
从AB包中加载资源时，引用计数+1
从AB包中卸载资源时，引用计数-1
当AB包引用计数为0时，意味着不再使用了，这时会从内存中卸载

**总结：Addressables内部会通过引用计数帮助我们管理内存**
只需要保证 加载和卸载资源配对使用即可

**举例说明**
```csharp
//创建两个一样的资源
//然后一个一个的释放他们的资源句柄
//观察他们创建出来的对象变化

//注意：使用第三种模式加载资源（从AB包中加载）
private List<AsyncOperationHandle<GameObject>> list = new List<AsyncOperationHandle<GameObject>>();

private void Update()
{
    //创建对象 记录异步操作句柄
    if(Input.GetKeyDown(KeyCode.Space)) //按一次空格 引用计数+1
    {
        AsyncOperationHandle<GameObject> handle = Addressables.LoadAssetAsync<GameObject>("Cube");
        handle.Completed += (obj) =>
        {
            Instantiate(obj.Result);
        };
        list.Add(handle);
    }

    //从创建对象中 释放异步操作句柄资源
    if (Input.GetKeyDown(KeyCode.Q)) //按一次Q 引用计数-1
    {
        if(list.Count > 0)
        {
            Addressables.Release(list[0]);
            list.RemoveAt(0);
        }
    }
    //当引用计数-到0时会自动卸载AB包 如果此时场景中存在资源 则会丢失
}
```

---

### 练习

> 1. 为之前的资源管理器添加用计数功能

```csharp
/// <summary>
/// 可寻址资源 信息
/// </summary>
public class AddressablesInfo
{
    //记录 异步操作句柄
    public AsyncOperationHandle handle;
    //记录 引用计数
    public uint count;
    public AddressablesInfo(AsyncOperationHandle handle)
    {
        this.handle = handle;
        count += 1;
    }
}

/// <summary>
/// Addressables可寻址资源加载管理器
/// </summary>
public class AddressablesMgr : BaseManager<AddressablesMgr>
{
    private AddressablesMgr() { }
    //用于存储已加载资源的容器
    public Dictionary<string, AddressablesInfo> resDic = new Dictionary<string, AddressablesInfo>();
    /// <summary>
    /// 异步加载资源
    /// </summary>
    /// <typeparam name="T">资源类型</typeparam>
    /// <param name="name">资源名</param>
    /// <param name="callBack">回调函数</param>
    public void LoadAssetAsync<T>(string name, Action<AsyncOperationHandle<T>> callBack)
    {
        //资源名 或 资源标签 _ 资源类型
        //Cube_GameObject
        string keyName = $"{name}_{typeof(T).Name}";
        AsyncOperationHandle<T> handle;
        if (resDic.ContainsKey(keyName)) //如果已经加载过资源
        {
            resDic[keyName].count += 1; //引用计数+1
            handle = resDic[keyName].handle.Convert<T>();//从字典中取出资源
            if (handle.IsDone) //是否加载结束
                callBack(handle);
            else //没有加载结束叠加回调函数
                handle.Completed += callBack;
            return;
        }
        //如果没有加载过资源
        //直接进行异步加载 并记录
        handle = Addressables.LoadAssetAsync<T>(name);
        handle.Completed += (obj) =>
        {
            if (obj.Status == AsyncOperationStatus.Succeeded)
                callBack(obj);
            else
            {
                Debug.LogWarning($"ID为{keyName}的资源加载失败");
                if (resDic.ContainsKey(keyName))
                    resDic.Remove(keyName);//移除容器中的该资源
            }
        };
        //第一次new 引用计数+1
        AddressablesInfo info = new AddressablesInfo(handle);
        resDic.Add(keyName, info);
    }
    /// <summary>
    /// 异步加载多个资源 或指定资源
    /// </summary>
    /// <typeparam name="T">资源类型</typeparam>
    /// <param name="mode">合并模式</param>
    /// <param name="callBack">回调函数</param>
    /// <param name="keys">资源、标签名</param>
    public void LoadAssetAsync<T>(Addressables.MergeMode mode, Action<T> callBack, params string[] keys)
    {
        //1 构建一个keyName
        //资源名 或 资源标签 _ 资源标签1 _ 资源标签2 _ ... 资源类型
        //Cube_HD_Red_GameObject
        List<string> list = new List<string>(keys);
        string keyName = "";
        foreach (string key in list)
            keyName += $"{key}_";
        keyName += typeof(T).Name;
        AsyncOperationHandle<IList<T>> handle;
        if (resDic.ContainsKey(keyName))
        {
            resDic[keyName].count += 1; //引用计数+1
            handle = resDic[keyName].handle.Convert<IList<T>>();
            if (handle.IsDone) //如果加载完毕
                foreach (T item in handle.Result)
                    callBack(item);
            else //如果没有加载完毕 等待加载完毕后执行
                handle.Completed += (obj) =>
                {
                    if (obj.Status == AsyncOperationStatus.Succeeded) //成功加载才执行
                        foreach (T item in obj.Result)
                            callBack(item);
                };
        }
        else
        {
            handle = Addressables.LoadAssetsAsync<T>(list, callBack, mode);
            handle.Completed += (obj) =>
            {
                if (obj.Status == AsyncOperationStatus.Failed)
                {
                    Debug.LogWarning($"ID为{keyName}的资源加载失败");
                    if (resDic.ContainsKey(keyName))
                        resDic.Remove(keyName);
                }
            };
            //第一次new 引用计数+1
            AddressablesInfo info = new AddressablesInfo(handle);
            resDic.Add(keyName, info);
        }
    }
    public void LoadAssetAsync<T>(Addressables.MergeMode mode, Action<AsyncOperationHandle<IList<T>>> callBack, params string[] keys)
    {
        //回调函数 传递出去的参数为异步加载的返回值
        //用于在外部处理handle的重载
    }
    /// <summary>
    /// 释放资源
    /// </summary>
    /// <typeparam name="T">资源类型</typeparam>
    /// <param name="name">资源名</param>
    public void Release<T>(string name)
    {
        string keyName = $"{name}_{typeof(T).Name}";
        if (resDic.ContainsKey(keyName))
        {
            //释放时引用计数-1
            resDic[keyName].count -= 1;
            if (resDic[keyName].count == 0) //引用计数为0时才真正释放资源
            {
                AsyncOperationHandle<T> handle = resDic[keyName].handle.Convert<T>();//从字典中取出资源
                Addressables.Release(handle);//卸载资源
                resDic.Remove(keyName);//移除容器中的该资源
            }
        }
    }
    /// <summary>
    /// 释放多个资源 或指定资源
    /// </summary>
    /// <typeparam name="T">资源类型</typeparam>
    /// <param name="keys">资源、标签名</param>
    public void Release<T>(params string[] keys)
    {
        List<string> list = new List<string>(keys);
        string keyName = "";
        foreach (string key in list)
            keyName += $"{key}_";
        keyName += typeof(T).Name;
        if (resDic.ContainsKey(keyName)) //如果存在资源 
        {
            //释放时引用计数-1
            resDic[keyName].count -= 1;
            if (resDic[keyName].count == 0) //如果引用计数为0 真正释放资源 
            {
                AsyncOperationHandle<IList<T>> handle = resDic[keyName].handle.Convert<IList<T>>();
                Addressables.Release(handle);
                resDic.Remove(keyName);
            }
        }
    }
    /// <summary>
    /// 粗暴的清除方法 
    /// 建议保证后面不再使用加载过的资源时执行
    /// </summary>
    public void Clear()
    {
        foreach (var item in resDic.Values)
            Addressables.Release(item.handle);
        resDic.Clear();
        AssetBundle.UnloadAllAssetBundles(true);
        Resources.UnloadUnusedAssets();
        GC.Collect();
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
