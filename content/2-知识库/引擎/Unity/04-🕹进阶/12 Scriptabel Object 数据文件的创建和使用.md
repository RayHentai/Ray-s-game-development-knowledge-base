# 12 Scriptabel Object 数据文件的创建和使用

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 创建

**优势的体现**
1. 更方便的配置数据，可以直接在Inspector当中配置数据
2. 项目之间的复用，我们可以拷贝继承ScriptableObject的脚本到任何工程中

**总结：创建ScriptableObject数据类非常简单**
1. 继承它
2. 声明需要的数据变量
3. 添加对应的特性，让我们可以在Unity中真正的创建出数据资源文件

---

### 自定义ScriptableObject数据容器

1. 继承ScriptableObject类
2. 在该类中声明成员（变量、方法等）

**注意：**
- 声明后，可以在Inspector窗口中看到变化
- 可以在其中进行设置，但是这些设置都是默认数据，并没有真正使用他们
- 这些关联信息都是通过脚本文件对应的Unity配置文件meta进行记录的
- 目前该数据只是一个数据容器模板，有了它之后才能根据它的信息创建对应的数据资源文件

![[Scriptable Object Inspector窗口参数.png]]

```csharp title:Data
public class MyData : ScriptableObject
{
    //声明成员时需要注意
    //可以声明任何类型的成员变量
    //但是需要注意：如果希望之后在Inspector窗口中能够编辑它
    //那你在这里声明的变量规则 要和 MonoBehavior当中public变量的规则是一样的
    public int i;
    public float f;
    public bool b;
    public GameObject obj;
    public Material m;
    public AudioClip audioClip;
    public VideoClip videoClip;
}
```

---

### 根据自定义的ScriptableObject数据容器创建数据文件

**注意：**
- 该创建功能，其实就是根据自定义数据容器类创建了一个配置文件
- 该文件中记录了对应的数据容器类信息，以及其中变量关联的信息
- 之后我们在使用它时，本质上也是通过反射创建对象进行使用

**具体的方法有两种：**
1. 为类添加CreateAssetMenu通过菜单创建资源特性
	- `[CreateAssetMenu(fileName = "默认文件名", menuName = "在Asset/Create菜单中显示的名字", order = 在Asset/Create菜单中的位置(多个时可以通过它来调整顺序))]`

```csharp
[CreateAssetMenu(fileName ="MyData", menuName ="ScriptableObject/我的数据", order = 0)]
public class MyData : ScriptableObject
{
    public int i;
    public float f;
    public bool b;
    public GameObject obj;
    public Material m;
    public AudioClip audioClip;
    public VideoClip videoClip;
```

2. 利用ScriptableObject的静态方法创建数据对象
	- 然后将数据对象保存在工程目录下

```csharp
public class ScriptableObjectTool
{
    [MenuItem("ScriptableObject/CreateMyData")]//特性 在上方菜单栏添加选项栏
    public static void CreateMyData()
    {
        //书写创建数据资源文件的代码
        MyData asset = ScriptableObject.CreateInstance<MyData>();

        //通过编辑器API 根据数据创建一个数据资源文件
        AssetDatabase.CreateAsset(asset, "Assets/Resources/MyDataTest.asset");
        //保存创建的资源
        AssetDatabase.SaveAssets();
        //刷新界面
        AssetDatabase.Refresh();
    }
}
```

---

### 练习

>1. 请使用ScriptableObject制作一个用于存储游戏设置信息的数据
>音乐音效开关，音乐音效大小

```csharp
[CreateAssetMenu(fileName = "MusicData", menuName = "ScriptableObject/音乐数据")]
public class MusicData : ScriptableObject
{
    public float musicValue;
    public float soundValue;
    public bool isMusicOpen;
    public bool isSoundOpen;
}
```

---

## 使用

**优势的体现**
1. 编辑器中的数据持久化
	- 通过代码修改数据对象中内容，会影响数据文件
	- 相当于达到了编辑器中数据持久化的目的(该数据持久化 只是在编辑模式下的持久，**发布运行时并不会保存数据**)

2. 复用数据
	- 如果多个对象关联同一个数据文件
	- 相当于他们复用了一组数据，内存上更加节约空间

**总结：**
- 创建出来的数据资源文件，可以把它理解成一种记录数据的资源
- 它的使用方式，和使用Unity当中的其它资源规则是一样的
- 比如：预设体、音频文件、视频文件、动画控制器文件、材质球等等
- 只不过通过继承ScriptableObject类生成的数据资源文件，它主要是和数据相关的

---

### 配置文件的使用

**具体的方法有两种：**
1. 通过Inspector中的public变量进行关联
	- 创建一个数据文件
	- 在继承MonoBehaviour类中申明数据容器类型的成员
	    - 在Inspector窗口进行关联

```csharp
public MyData data;
```

2. 通过资源加载的信息关联
	- 加载数据文件资源
	- **注意：Resources、AB包、Addressables都支持加载继承ScriptableObject的数据文件**

```csharp
public MyData data;
data = Resources.Load<MyData>("MyDataTest");
```

**注意：如果多个对象关联同一个数据容器文件，他们共享的是一个对象**
- 因为是引用对象，所以在其中任何地方修改后，其它地方也会发生改变

---

#### 练习

>1. 请使用上节课做的游戏设置信息数据文件做一个设置界面，使用该数据文件来更新界面并且做到每次重启，游戏数据能被记录

```csharp
public class SettingPanel : MonoBehaviour
{
    public Slider sliMusic;
    public Slider sliSound;
    public Toggle togMusic;
    public Toggle togSound;
    public MusicData musicData;
    void Start()
    {
        UpdatePanel();
        sliMusic.onValueChanged.AddListener((value) => { musicData.musicValue = value; });
        sliSound.onValueChanged.AddListener((value) => { musicData.soundValue = value; });
        togMusic.onValueChanged.AddListener((value) => { musicData.isMusicOpen = value; });
        togSound.onValueChanged.AddListener((value) => { musicData.isSoundOpen = value; });
    }

    private void UpdatePanel()
    {
        sliMusic.value = musicData.musicValue;
        sliSound.value = musicData.soundValue;
        togMusic.isOn = musicData.isMusicOpen;
        togSound.isOn = musicData.isSoundOpen;
    }
}
```

---

### Scriptable Object 的生命周期函数

**ScriptableObject和MonoBehavior很类似，它也存在生命周期函数**
但是生命周期函数的数量更少
主要做了解，一般使用较少

```csharp
    private void Awake()
    {
        Debug.Log("数据文件创建时会调用");
    }

    private void OnEnable()
    {
        Debug.Log("ScriptableObject 创建或者加载对象时调用");
    }

    private void OnDisable()
    {
        Debug.Log("ScriptableObject对象销毁时、即将重新加载脚本程序集时调用");
    }

    private void OnDestroy()
    {
        Debug.Log("ScriptableObject对象将被销毁时调用");
    }


    private void OnValidate()
    {
        Debug.Log("编辑器才会调用的函数，Unity在加载脚本或者Inspector窗口中更改值时调用");
    }
```

---

### 非持久化数据

**非持久化数据指的是不管在编辑器模式还是在发布后都不会持久化的数据**
可以根据自己的需求随时创建对应数据对象进行使用
就好像直接new一个数据结构类对象

**创建**
- 利用ScriptableObject中的静态方法 `CreateInstance<>()`
- 该方法可以在运行时创建出指定继承ScriptableObject的对象
- 该对象只存在于内存当中，可以被GC，调用一次就创建一次
- 通过这种方式创建出来的数据对象 它里面的默认值 不会受到脚本中设置的影响，是声明类时的默认值

```csharp
public MyData data;
data = ScriptableObject.CreateInstance("MyData") as MyData;
data = ScriptableObject.CreateInstance<MyData>();
```

**意义**
只希望在运行时能有一组唯一的数据可以使用
但是这个数据又不太希望保存为数据资源文件浪费硬盘空间
那么ScriptableObject的非持久化数据就有了存在的意义

**特点：只在运行时使用，在编辑器模式下也不会保存在本地**

---

#### 练习

> 1. 请使用上一节课设置界面练习题的基础上
> 不直接关联设置数据文件，而是在运行时创建，让其变为不持久化数据

```csharp
public class SettingPanel : MonoBehaviour
{
    public Slider sliMusic;
    public Slider sliSound;
    public Toggle togMusic;
    public Toggle togSound;
    public MusicData musicData;
    void Start()
    {
        musicData = ScriptableObject.CreateInstance<MusicData>();//只加了这一句代码
        UpdatePanel();
        sliMusic.onValueChanged.AddListener((value) => { musicData.musicValue = value; });
        sliSound.onValueChanged.AddListener((value) => { musicData.soundValue = value; });
        togMusic.onValueChanged.AddListener((value) => { musicData.isMusicOpen = value; });
        togSound.onValueChanged.AddListener((value) => { musicData.isSoundOpen = value; });
    }

    private void UpdatePanel()
    {
        sliMusic.value = musicData.musicValue;
        sliSound.value = musicData.soundValue;
        togMusic.isOn = musicData.isMusicOpen;
        togSound.isOn = musicData.isSoundOpen;
    }
}
```

---

### 数据持久化的实现

ScriptableObject的数据，由于它在游戏发布运行过程中无法被持久化
可以利用 PlayerPrefs、XML、Json、2进制等等方式
让其可以达到被真正持久化的目的

但是并不建议利用ScriptableObject来做数据持久化，有点画蛇添足的意思了

---

#### 写

```csharp
MyData data = ScriptableObject.CreateInstance<MyData>();
data.i = 9999;
data.f = 6.6f;
data.b = true;
//将数据对象 序列化为 json字符串
string str = JsonUtility.ToJson(data);
//把数据序列化后的结果 存入指定路径当中
File.WriteAllText(Application.persistentDataPath + "/testJson.json", str);
```

---

#### 读

```csharp
//从本地读取 Json字符串
string str = File.ReadAllText(Application.persistentDataPath + "/testJson.json");
//根据json字符串反序列化出数据 将内容覆盖到数据对象中
JsonUtility.FromJsonOverwrite(str, data); //FromJsonOverwrite方法是直接覆盖
data.PrintInfo();
```

---

#### 练习

> 1. 请在上节课的练习题基础上
> 把不持久化数据持久化，可以记录下相关信息，下次启动时能够记录上次设置的内容

```csharp title:面板脚本
public class SettingPanel : MonoBehaviour
{
    public Slider sliMusic;
    public Slider sliSound;
    public Toggle togMusic;
    public Toggle togSound;
    public MusicData musicData;
    void Start()
    {
        musicData = ScriptableObject.CreateInstance<MusicData>();
        UpdatePanel();
        sliMusic.onValueChanged.AddListener((value) => { musicData.musicValue = value; });
        sliSound.onValueChanged.AddListener((value) => { musicData.soundValue = value; });
        togMusic.onValueChanged.AddListener((value) => { musicData.isMusicOpen = value; });
        togSound.onValueChanged.AddListener((value) => { musicData.isSoundOpen = value; });
    }
    private void UpdatePanel()
    {
        sliMusic.value = musicData.musicValue;
        sliSound.value = musicData.soundValue;
        togMusic.isOn = musicData.isMusicOpen;
        togSound.isOn = musicData.isSoundOpen;
    }
    /// <summary>
    /// 测试
    /// </summary>
    private void Update()//添加一个用于测试的输入检测
    {
        if (Input.GetKeyDown(KeyCode.Space))
            musicData.SaveData();
    }
}
```

```csharp title:data
[CreateAssetMenu(fileName = "MusicData", menuName = "ScriptableObject/音乐数据")]
public class MusicData : ScriptableObject
{
    public float musicValue;
    public float soundValue;
    public bool isMusicOpen;
    public bool isSoundOpen;
    private void Awake()//生命周期函数中加入读取数据的逻辑
    {
        // 判断是否存在持久化的数据文件
        if (File.Exists(Application.persistentDataPath + "/MusicData.json"))
        {
            string jsonStr = File.ReadAllText(Application.persistentDataPath + "/MusicData.json");
            JsonUtility.FromJsonOverwrite(jsonStr, this);
        }
    }
    /// <summary>
    /// 保存数据的方法
    /// </summary>
    public void SaveData()//添加一个保存数据的方法
    {
        string jsonStr = JsonUtility.ToJson(this);
        File.WriteAllText(Application.persistentDataPath + "/MusicData.json", jsonStr);
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

# API速查


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
