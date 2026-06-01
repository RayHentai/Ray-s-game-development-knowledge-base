# 31 Addressables 指定资源加载

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

1.可以根据自己的需求选择合适的标识类进行资源加载
2.资源加载和场景加载都是通过**异步进行加载**
3.需要注意异步加载资源使用时必须保证资源已经被加载成功了，否则会报错

---

## Addressables中的资源标识类

命名空间：using UnityEngine.AddressableAssets

AssetReference                          //通用资源标识类 可以用来加载任意类型资源
AssetReferenceAtlasedSprite     //图集资源标识类
AssetReferenceGameObject      //游戏对象资源标识类
AssetReferenceSprite                 //精灵图片资源标识类
AssetReferenceTexture              //贴图资源标识类
AssetReferenceTexture2D         //2D贴图
AssetReferenceTexture3D         //3D贴图
AssetReferenceT<>                  //指定类型标识类
AssetReference //场景

```csharp
using UnityEngine.AddressableAssets;

public AssetReference assetReference;
public AssetReferenceAtlasedSprite asReference;
public AssetReferenceGameObject gameObjectReference;
public AssetReferenceSprite spriteReference;
public AssetReferenceTexture textureReference;

public AssetReferenceT<AudioClip> audioReference;
public AssetReferenceT<RuntimeAnimatorController> controller;
public AssetReferenceT<TextAsset> textReference;

public AssetReferenceT<Material> materialRed;

public AssetReference sceneReference;
```

通过不同类型标识类对象的声明，可以在Inspector窗口中筛选关联的资源对象
![[Inspector窗口 关联可寻址资源 图示.png|414]]

---

## 加载、释放资源

注意：所有Addressables加载相关都使用异步加载

```csharp
using UnityEngine.ResourceManagement.AsyncOperations;
AsyncOperationHandle<GameObject> handle = assetReference.LoadAssetAsync<GameObject>();
```

**加载成功后使用**
1. 通过事件函数传入的参数判断加载是否成功，并且创建
2. 通过资源标识类对象判断，并且创建

通过异步加载返回值 对完成进行事件监听

**使用完资源后释放**
1. 释放资源方法后，资源标识类中的资源会置空，但是AsyncOperationHandle类中的对象不为空
2. 释放资源不会影响场景中被实例化出来的对象，但是会影响使用的资源

```csharp
//添加函数
AsyncOperationHandle<GameObject> handle = assetReference.LoadAssetAsync<GameObject>();
handle.Completed += TestFun; 
private void TestFun(AsyncOperationHandle<GameObject> handle)
{
    //加载成功后 使用加载的资源
    //判断是否加载成功
    if(handle.Status == AsyncOperationStatus.Succeeded)
        Instantiate(handle.Result);//Result是加载成功之后返回的结果 是一个<GameObject>
}

//或者直接使用匿名函数
assetReference.LoadAssetAsync<GameObject>().Completed += (handle) =>
{
    //使用传入的参数（建议）
    //判断是否加载成功
    if (handle.Status == AsyncOperationStatus.Succeeded)
    {
        GameObject cube = Instantiate(handle.Result);
        //一定资源加载过后 使用完后 再去释放
        assetReference.ReleaseAsset();

        materialRed.LoadAssetAsync().Completed += (obj) =>
        {
            cube.GetComponent<MeshRenderer>().material = obj.Result;
            //这样会造成使用这个资源的对象 资源丢失
            //在第二种模式 模拟加载AB包时中不会丢失材质球
            //在第三种模式 真正加载AB包时 材质会丢失
            materialRed.ReleaseAsset(); 

            //这个异步加载传入对象的资源 不会被置空
            print(obj.Result); // 资源名
            //这个是 资源标识类的资源 会被置空
            print(materialRed.Asset); // null
        };
    }
    //使用标识类创建 建议用泛型创建 更灵活
    if(assetReference.IsDone) //是否加载完成
        Instantiate(assetReference.Asset);
};

//加载指定资源
audioReference.LoadAssetAsync().Completed += (handle) =>
{
    //使用音效
};

//加载场景
sceneReference.LoadSceneAsync().Completed += (handle) =>
{
    //初始化场景的一些信息
    print("场景加载结束");
};
```

<iframe src="file:///D:/OneDrive/文档/Obsidian/Hentai的知识库/4-归档/HTML/卸载资源引用计数和引用关系的演示.html" width="100%" height="700px" style="border:none;"></iframe>

---

## 其他操作

**直接实例化对象**
```csharp
//只适用于 想要实例化的 对象 才会直接使用该方法 一般都是GameObject预设体
public AssetReferenceGameObject gameObjectReference;
gameObjectReference.InstantiateAsync();//可填入初始化参数
```

**自定义一个指定类型的标识类（旧版本 了解即可）**
  自定义类 继承` AssetReferenceT<类型>`类 即可自定义一个指定类型的标识类
  该功能主要用于Unity2020.1之前，因为之前的版本不能直接使用 `AssetReferenceT` 泛型字段
  ```csharp
public class AssetReferenceAudio: AssetReferenceT<AudioClip>
{
	public AssetReferenceAudio(string guid) : base(guid) {  }
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

## API速查


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
