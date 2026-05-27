# 03 CSharp对象的序列化和反序列化

**所属模块**：[[00 二进制 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 序列化

**关键类**
- 内存流对象
	- 类名：MemoryStream
	- 命名空间：System.IO

- 2进制格式化对象
	- 类名：BinaryFormatter
	- 命名空间：System.Runtime.Serialization.Formatters.Binary

**主要方法：序列化方法 Serialize**

**注意：如果要使用C#自带的序列化2进制方法，申明类时需要添加`[System.Serializable]`特性不然会报错**

```csharp
[System.Serializable]
public class Person
{
    public int age = 1;
    public string name = "市民";
    public int[] ints = new int[] { 1, 2, 3, 4, 5 };
    public List<int> list = new List<int>() { 1, 2, 3, 4 };
    public Dictionary<int, string> dic = new Dictionary<int, string>() { { 1,"123"},{ 2,"1223"},{ 3,"435345" } };
    public StructTest st = new StructTest(2, "123");
    public ClssTest ct = new ClssTest();
}

[System.Serializable]
public struct StructTest
{
    public int i;
    public string s;
    public StructTest(int i, string s)
    {
        this.i = i;
        this.s = s;
    }
}

[System.Serializable]
public class ClssTest
{
    public int i = 1;
}

Person p = new Person();
//方法一：使用内存流得到2进制字节数组
//主要用于得到字节数组 可以用于网络传输
using (MemoryStream ms = new MemoryStream())
{
    //2进制格式化程序
    BinaryFormatter bf = new BinaryFormatter();
    //序列化对象 生成2进制字节数组 写入到内存流当中
    bf.Serialize(ms, p);
    //得到对象的2进制字节数组
    byte[] bytes = ms.GetBuffer();
    //存储字节
    File.WriteAllBytes(Application.dataPath + "/Test.test", bytes);
    //关闭内存流
    ms.Close();
}

//方法二：使用文件流进行存储
//主要用于存储到文件中
using (FileStream fs = new FileStream(Application.dataPath + "/Test.test", FileMode.OpenOrCreate, FileAccess.Write))
{
    //2进制格式化程序
    BinaryFormatter bf = new BinaryFormatter();
    //序列化对象 生成2进制字节数组 写入到内存流当中
    bf.Serialize(fs, p);
    fs.Flush();
    fs.Close();
}
```

---

## 反序列化

---

#### 文件中的数据

**关键类**
- FileStream文件流类
- BinaryFormatter 2进制格式化类

**主要方法：Deserizlize 通过文件流打开指定的2进制数据文件** 

```csharp
using (FileStream fs = File.Open(Application.dataPath + "/Test.test", FileMode.Open, FileAccess.Read))
{
    //申明一个 2进制格式化类
    BinaryFormatter bf = new BinaryFormatter();
    //反序列化
    Person p = bf.Deserialize(fs) as Person;

    fs.Close();
}
```

---

#### 网络传输的数据

**关键类**
- MemoryStream内存流类
- BinaryFormatter 2进制格式化类

**主要方法：Deserizlize**


```csharp
//目前没有网络传输 还是直接从文件中获取
byte[] bytes = File.ReadAllBytes(Application.dataPath + "/Test.test");
//申明内存流对象 一开始就把字节数组传输进去
using (MemoryStream ms = new MemoryStream(bytes))
{
    //申明一个 2进制格式化类
    BinaryFormatter bf = new BinaryFormatter();
    //反序列化
    Person p = bf.Deserialize(ms) as Person;

    ms.Close();
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

## 练习

> 1. 请实现一个管理类，于快捷读写自定义类对象数据

```csharp
public class BinaryDataMgr
{
    private static BinaryDataMgr instance = new BinaryDataMgr();
    public static BinaryDataMgr Instance => instance;
    private BinaryDataMgr() { }
    private string SAVE_PATH = Application.persistentDataPath + "/Data/";
    public void SavaData(object data, string fileName) 
    {
        if (!Directory.Exists(SAVE_PATH))//判断是否有文件夹
            Directory.CreateDirectory(SAVE_PATH);//没有则创建
        using (FileStream fs = new FileStream(SAVE_PATH + fileName + ".data", FileMode.OpenOrCreate, FileAccess.Write))
        {
            BinaryFormatter bf = new BinaryFormatter();
            bf.Serialize(fs, data);//序列化
            fs.Close();
        }
    }
    public T LoadData<T>(string fileName) where T : class
    {
        if (!File.Exists(SAVE_PATH + fileName + ".data"))
            return default(T);
        T data;
        using (FileStream fs = File.Open(SAVE_PATH + fileName + ".data", FileMode.Open, FileAccess.Read))
        {
            BinaryFormatter bf = new BinaryFormatter();
            data = bf.Deserialize(fs) as T; //反序列化
            fs.Close();
        }
        return data;
    }
}
```


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
