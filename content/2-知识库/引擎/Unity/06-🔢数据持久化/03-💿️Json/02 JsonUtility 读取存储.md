# 02 JsonUtility 读取存储

**所属模块**：[[00 Json 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

>JsonUtlity是unity自带的用于解析Json的公共类

**它可以将内存中对象序列化为Json格式的字符串，将Json字符串反序列化为类对象**

**注意：**
1.  Jsonutility 无法直接读取数据集合，会报错，可以改变Json数据，让一个对象包裹集合就可以正常读取
2. 文本编码格式需要是 UTF-8 不然无法加载

---

## 在文件中存读字符串

**注意：文件路径参数必须是存在的文件路径，没有对应文件夹会报错**

```csharp
//1 在指定路径文件中 存储字符串
//参数一：存储路径
//参数二：存储的字符串内容
File.WriteAllText(Application.persistentDataPath + "/Test.json", "字符串");

//2 在指定路径文件中 读取字符串
string str = File.ReadAllText(Application.persistentDataPath + "/Test.json");
```

---

## 序列化

**注意：**
1. float序列化时看起来会有一些误差
2. 自定义类需要加上序列化特性`[System.Serializable]`，最外层的类不用
3. 想要序列化私有变量需要加上特性`[SerializeField]`
4. JsonUtility不支持字典
5. JsonUtility存储null对象不会是null，而是默认值的数据

```csharp
string jsonStr = JsonUtility.ToJson(对象);
File.WriteAllText(Application.persistentDataPath + "/Test.json", jsonStr);
```

---

## 反序列化

注意：如果Json中数据少了，读取到内存中类对象中时不会报错

```csharp
string jsonStr = File.ReadAllText(Application.persistentDataPath + "/Test.json");
Test test = JsonUtility.FromJson(jsonStr, typeof(Test)) as Test;
Test test = JsonUtility.FromJson<Test>(jsonStr);
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

## 优先级 / 执行顺序

> 如果涉及优先级、执行顺序、作用域等，在这里说明

---

## 练习

> 1. 有一个玩家数据类，请为该类写一个方法结合JsonUtiity知识点，完成对象的序列化和反序列化

```csharp
public class Item
{
	public int id;
	public int num;
	public Item(int id, int num) { this.id = id; this.num = num; }
}
public class PlayerInfo
{
	public string name;
	public int atk;
	public int def;
	public float moveSpeed;
	public double roundSpeed;
	public Item weapon;
	public List<int> listInt;
	public List<Item> itemList;
	public Dictionary<int, Item> itemDic;
	public Dictionary<string, Item> itemDic2;
	private int privateI = 1;
	protected int protectedI = 2;
}
```

```csharp
    private void SaveData(PlayerInfo obj, string name)
    {
        string jsonStr = JsonUtility.ToJson(obj);
        File.WriteAllText(Application.persistentDataPath + "/" + name +".Test", jsonStr);
    }
    private PlayerInfo LoadData(string name)
    {
        string jsonStr = File.ReadAllText(Application.persistentDataPath + "/" + name + ".Test");
        return JsonUtility.FromJson<PlayerInfo>(jsonStr);
    }
```

---

## API 速查

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
