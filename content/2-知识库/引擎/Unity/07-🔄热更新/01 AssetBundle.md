# 01 AssetBundle

**所属模块**：[[00 热更新 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

**AB包：**
特定于平台的资产压缩包，有点类似压缩文件
资产包括：模型、贴图、预设体、音效、材质球等等

**Resources 和 AB包的区别**
![[Resources 和 AB包的区别.png|401]]

**AB包的优点：**
- 减小包体大小 — 压缩资源、减少初始包大小
- 热更新 — 资源热更新、脚本热更新

![[AB包的热更新 图示.png|390]]

---

## 生成AB包资源文件

有两种方法
1. Unity编辑器开发，自定义打包工具
2. 官方提供好的打包工具：Asset Bundle Browser

**添加Asset Bundle Browser**
Windows -> Package Manager -> Asset Bundle Browser

**如果没有搜索到**
1. 在项目中打开Package Manager菜单：**Windows** > **Package Manager**）。
2. 单击窗口左上角的 **+**（添加）按钮。
3. 选择 **Add package from git URL…**
4. 输入`https://github.com/Unity-Technologies/AssetBundles-Browser.git` 作为 URL
5. 单击 **Add**。

**打包工具窗口：**
Windows -> AssetBundle Browser

选中预设体资源 在下方会出现打包选项
点击None 选择New 为资源添加一个包名即可
设置完之后就会在打包窗口中显示该包中的所有资源
![[AssetBundle 打包选项.png]]

在打包工具窗口的Build中设置完参数点击Build后 会生成一系列文件
与文件夹名相同的Test为 主包 和 AB包依赖相关信息
model和其他则为自己设置过标签的 资源文件 和 AB包文件信息
不带后缀的文件为 资源文件 里面是二进制数据
.manifest 文件为 对应的资源文件相关的配置信息，如资源信息，依赖关系，版本信息等等
![[Asset Bundle 生成文件.png]]

---

### 窗口参数

![[Build 参数.png]]

---

## 加载AB包资源

**注意：AB包不能重复加载，会报错**

```csharp title:同步加载
//1 加载AB包
AssetBundle ab = AssetBundle.LoadFromFile(Application.streamingAssetsPath + "/model");
//2 加载AB包中的资源
//参数可以传入资源的名字和类型 也有泛型重载 建议使用泛型重载 
GameObject obj = ab.LoadAsset<GameObject>("Cube");
Instantiate(obj);
```

```csharp title:异步加载
//异步加载 — 协程
StartCoroutine(LoadABRes("model", "Sphere"));

IEnumerator LoadABRes(string ABName, string resName)
{
    AssetBundleCreateRequest abcr = AssetBundle.LoadFromFileAsync(Application.streamingAssetsPath + "/" + ABName);
    yield return abcr;
    AssetBundleRequest abr = abcr.assetBundle.LoadAssetAsync<GameObject>(resName);
    yield return abr;
    Instantiate(abr.asset);
}
```

```csharp title:卸载
//卸载所有AB包 参数为true代表把已经加载的资源也卸载
AssetBundle.UnloadAllAssetBundles(false);
//卸载AB包 参数为true代表把已经加载的资源也卸载
AssetBundle ab = AssetBundle.LoadFromFile(Application.streamingAssetsPath + "/model");
ab.Unload(false);
```

---

## AB包依赖

一个资源身上用到了别的AB包中的资源，这个时候如果只加载自己的AB包
通过它创建对象会出现资源丢失的情况
这种时候，**需要把依赖包一起加载**才能正常

如果一个资源的依赖包非常多，可以**利用主包获取依赖信息**

```csharp
//加载主包
AssetBundle abMain = AssetBundle.LoadFromFile(Application.streamingAssetsPath + "/" + "Test");

//加载主包中的固定文件
AssetBundleManifest abManifest = abMain.LoadAsset<AssetBundleManifest>("AssetBundleManifest");

//从固定文件中得到依赖信息
string[] strs = abManifest.GetAllDependencies("model");

//得到了依赖包的名字 加载所有的依赖包
for (int i = 0;i < strs.Length； i++)
{
	AssetBundle.LoadFromFile(Application.streamingAssetsPath + "/" + strs[i]);
}
//这种方法有一个缺点 加载的是这个包依赖的所有包 而不是这个包的加载的某个资源依赖的所有包
```

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
