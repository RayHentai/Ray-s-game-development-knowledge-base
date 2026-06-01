# 33 Addressables 动态加载资源

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 动态加载单个资源

根据名字或标签加载单个资源相对之前的指定加载资源更加灵活
- 主要通过Addressables类中的静态方法传入资源名或标签名进行加载
- **注意：**
	1. 如果存在同名或同标签的同类型资源，我们无法确定加载的哪一个，它会自动加载找到的第一个满足条件的对象
	2. 如果存在同名或同标签的不同类型资源，我们可以根据泛型类型来决定加载哪一个

释放资源时需要传入之前记录的AsyncOperationHandle对象
- **注意：一定要保证资源使用完毕过后再释放资源**

场景异步加载可以自己手动激活加载完成的场景

---

### 加载和释放资源

**注意：**
1. 如果存在同名或同标签的同类型资源，我们确定加载的哪一个，它会自动加载找到的第一个满足条件的对象
2. 如果存在同名或同标签的不同类型资源，可以根据泛型类型来决定加载哪一个，相当于用三个变量判断到底加载资源，资源名、标签名、资源类型

```csharp
AsyncOperationHandle<GameObject> handle;
//通过资源名或标签加载 ()中的参数填入资源名或者标签
handle = Addressables.LoadAssetAsync<GameObject>("Cube");
handle.Completed += (handle) =>
{
    //判断加载成功
    if (handle.Status == AsyncOperationStatus.Succeeded)
        Instantiate(handle.Result);

    //一定要是 加载完成后 使用完毕后 再去释放
    //不管任何资源 只要释放后 都会影响之前在使用该资源的对象
    Addressables.Release(handle);
};
//一步到位
Addressables.LoadAssetAsync<GameObject>("Red").Completed += (handle) =>
{
    //判断加载成功
    if (handle.Status == AsyncOperationStatus.Succeeded)
        Instantiate(handle.Result);
};

private void OnDestroy()
{
	//动态释放资源写在这里比较好
    Addressables.Release(handle);
}

```

---

### 加载场景

```csharp
//参数一：场景名
//参数二：加载模式 （叠加还是单独,叠加就是两个场景一起显示,单独就是只保留新加载的场景，正常情况为单独）
//参数三：场景加载是否激活，如果为false，加载完成后不会直接切换，需要自己使用返回值中的ActivateAsync方法
//参数四：场景加载的异步操作优先级
Addressables.LoadSceneAsync("SampleScene", UnityEngine.SceneManagement.LoadSceneMode.Single, false).Completed += (obj)=> {
    //比如说 手动激活场景
    obj.Result.ActivateAsync().completed += (a) =>
    {
        //然后再去创建场景上的对象
        //然后再去隐藏 加载界面
        //注意：场景资源也是可以释放的，并不会影响当前已经加载出来的场景，因为场景的本质只是配置文件
        Addressables.Release(obj);
    };
/};
```

---

### 练习

> 1. 尝试自己写一个Addressables资源管理器，可以通过名字加载单个资源或场景，并管理资源相关内容

```csharp
/// <summary>
/// Addressables可寻址资源加载管理器
/// </summary>
public class AddressablesMgr : BaseManager<AddressablesMgr>
{
    private AddressablesMgr() { }
    //用于存储已加载资源的容器 里氏替换原则用基接口装子类资源
    public Dictionary<string, IEnumerator> resDic = new Dictionary<string, IEnumerator>();
    /// <summary>
    /// 异步加载资源
    /// </summary>
    /// <typeparam name="T">资源类型</typeparam>
    /// <param name="name">资源名</param>
    /// <param name="callBack">回调函数</param>
    public void LoadAssetAsync<T>(string name, Action<AsyncOperationHandle<T>> callBack)
    {
        string keyName = $"{name}_{typeof(T).Name}";
        AsyncOperationHandle<T> handle;
        if (resDic.ContainsKey(keyName)) //如果已经加载过资源
        {
            handle = (AsyncOperationHandle<T>)resDic[keyName];//从字典中取出资源
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
    /// 释放资源
    /// </summary>
    /// <typeparam name="T">资源类型</typeparam>
    /// <param name="name">资源名</param>
    public void Release<T>(string name) 
    {
        string keyName = $"{name}_{typeof(T).Name}";
        if (resDic.ContainsKey(keyName)) 
        {
            AsyncOperationHandle<T> handle = (AsyncOperationHandle<T>)resDic[keyName];//从字典中取出资源
            Addressables.Release(handle);//卸载资源
            resDic.Remove(keyName);//移除容器中的该资源
        }
    }
    /// <summary>
    /// 粗暴的清除方法
    /// 建议保证后面不再使用加载过的资源时执行
    /// </summary>
    public void Clear()
    {
        resDic.Clear();
        AssetBundle.UnloadAllAssetBundles(true);
        Resources.UnloadUnusedAssets();
        GC.Collect();
    }
}
```

```csharp title:测试
public class TestMgr : MonoBehaviour
{
    void Start()
    {
        AddressablesMgr.Instance.LoadAssetAsync<GameObject>("Cube", (obj) => 
        {
            Instantiate(obj.Result);
        });
        AddressablesMgr.Instance.LoadAssetAsync<GameObject>("Cube", (obj) =>
        {
            Instantiate(obj.Result, Vector3.right * 5, Quaternion.identity);
            AddressablesMgr.Instance.Release<GameObject>("Cube");
        });
    }
}
```

---

## 动态加载多个资源

1. 可以根据 资源名或标签名+资源类型 来加载所有满足条件的对象
2. 可以根据 资源名+标签名+资源类型+合并模式 来加载指定的单个或者多个对象

**根据资源名或标签名加载多个对象**
```csharp
//加载资源
//参数一：资源名或标签名
//参数二：加载结束后的回调函数
//参数三：如果为true表示当资源加载失败时，会自动将已加载的资源和依赖都释放掉；如果为false，需要自己手动来管理释放
//注意：还是可以通过泛型类型，来筛选资源类型 传入Object 代表不限定类型
Addressables.LoadAssetsAsync<Object>("Red", (obj) =>
{
    print(obj.name);
});


//如果要进行资源释放管理 那么需要使用这种方式 要方便一些
//因为得到了返回值对象 就可以释放资源了
AsyncOperationHandle<IList<Object>> handle = Addressables.LoadAssetsAsync<Object>("Red", (obj) =>
{
    
});

handle.Completed += (obj) =>
{
    foreach (var item in obj.Result)
    {
        print(item.name);
    }
    //释放资源
    Addressables.Release(obj);
};
```

**根据多种信息加载对象**
```csharp
//参数一：想要加载资源的条件列表（资源名、Lable名）
//参数二：每个加载资源结束后会调用的函数，会把加载到的资源传入该函数中
//参数三：可寻址的合并模式，用于合并请求结果的选项。
	//如果键（Cube，Red）映射到结果（[1,2,3]，[1,3,4]），数字代表不同的资源
	//None：不发生合并，将使用第一组结果 结果为[1,2,3]
	//UseFirst：应用第一组结果 结果为[1,2,3]
	//Union：合并所有结果 结果为[1,2,3,4]
	//Intersection：使用相交结果 结果为[1,3]
//参数四：如果为true表示当资源加载失败时，会自动将已加载的资源和依赖都释放掉
//       如果为false，需要自己手动来管理释放
List<string> strs = new List<string>() { "Cube", "HD" };
Addressables.LoadAssetsAsync<Object>(strs, (obj) => {
    print(obj.name);
}, Addressables.MergeMode.Intersection);

//注意：还是可以通过泛型类型，来筛选资源类型
```

### 练习

> 1.尝试在上一个Addressables资源管理器中，提供一个批量或指定加载释放资源的方法 


```csharp
/// <summary>
/// Addressables可寻址资源加载管理器
/// </summary>
public class AddressablesMgr : BaseManager<AddressablesMgr>
{
    private AddressablesMgr() { }
    //用于存储已加载资源的容器 里氏替换原则用基接口装子类资源
    public Dictionary<string, IEnumerator> resDic = new Dictionary<string, IEnumerator>();
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
            handle = (AsyncOperationHandle<T>)resDic[keyName];//从字典中取出资源
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
            handle = (AsyncOperationHandle<IList<T>>)resDic[keyName];
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
            AsyncOperationHandle<T> handle = (AsyncOperationHandle<T>)resDic[keyName];//从字典中取出资源
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
            AsyncOperationHandle<IList<T>> handle = (AsyncOperationHandle<IList<T>>)resDic[keyName];
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
        resDic.Clear();
        AssetBundle.UnloadAllAssetBundles(true);
        Resources.UnloadUnusedAssets();
        GC.Collect();
    }
}
```

```csharp title:测试
public class TestMgr : MonoBehaviour
{
    void Start()
    {
        AddressablesMgr.Instance.LoadAssetAsync<Object>(Addressables.MergeMode.Intersection, (obj) =>
        {
            print(obj.name);
        }, "Cube", "Red");
        AddressablesMgr.Instance.LoadAssetAsync<Object>(Addressables.MergeMode.Intersection, (obj) =>
        {
            print(obj.name);
        }, "Cube", "Red");
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
