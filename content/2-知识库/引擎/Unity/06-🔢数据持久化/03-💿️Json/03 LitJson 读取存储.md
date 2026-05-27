# 03 LitJson 读取存储

**所属模块**：[[00 Json 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

>LitJson 是一个第三方库，用于处理Json的序列化和反序列化
>LitJson 是C#编写的，体积小、速度快、易于使用
>它可以很容易的嵌入到我们的代码中，只需要将 LitJson 代码拷贝到工程中即可

**获取：**
1. 前往 LitJson 官网
2. 通过官网前往GitHub获取最新版本代码
3. 将代码拷贝到unity工程中即可开始使用LitJson

**注意：**
1. LitJson 可以读取数据集合
2. 文本编码格式需要是UTF-8，不然无法加载

---

## 序列化

**注意：**
1. 相对 JsonUtlity 不需要加特性
2. 不能序列化私有变量
3. 支持字典类型，字典的键建议都是字符串，因为Json的特点Json中的键会加上双引号
4. 需要引用 LitJson 命名空间
5. LitJson 可以准确保存null类型

```csharp
string jsonStr = JsonMapper.ToJson(test);
File.WriteAllText(Application.persistentDataPath + "/Test.json", jsonStr);
```

---

## 反序列化

**注意：**
1. 类结构需要无参构造函数，否则反序列化时报错
2. 字典虽然支持，但是键在使用为数值时会有问题，需要使用字符串类型

```csharp
string jsonStr = File.ReadAllText(Application.persistentDataPath + "/Test.json"); 
//JsonData 是 LitJson提供的类对象 可以用键值对的形式去访问其中的内容
JsonData data = JsonMapper.ToObject(jsonStr);
data["name"]//通过索引器的方式去访问信息
Test test = JsonMapper.ToObject<Test>(jsonStr);//泛型重载

//LitJson 可以读取数据集合
List<Test> listTest = JsonMapper.ToObject<List<Test>>("数据集合字符串");
Dictionary<string, int> dic = JsonMapper.ToObject<Dictionary<string, int>>("数据集合字符串");
```

---

## JsonUtility 和 LitJson 对比

**同：**
1. 都是用于Json的序列化反序列化
2. Json文档编码格式必须是UTF-8
3. 都是通过静态类进行方法调用

**异：**
1. JsonUtlity 是unity自带，LitJson是第三方需要引用命名空间
2. JsonUtlity 使用时自定义类需要加特性，LitJson 不需要
3. JsonUtlity 支持私有变量（加特性），LitJson 不支持
4. JsonUtlity 不支持字典，LitJson 支持（但是键只能是字符串）
5. JsonUtlity 不能直接将数据反序列化为数据集合（数组字典），LitJson 可以
6. JsonUtlity 对自定义类不要求有无参构造，LitJson 需要
7. JsonUtlity 存储空对象时会存储默认值而不是null，LitJson 会存null

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- 场景一：
- 场景二：
- 反例（不该用的时候）：

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- Json文件最后一个元素不需要加逗号，会报错
- 

---

## 练习

> 1. 有一个玩家数据类，请为该类写一个方法结合LitJson知识点完成对象的序列化和反序列化

```csharp
public class LitJson_Test : MonoBehaviour
{
    void Start()
    {
        PlayerInfo p = new PlayerInfo();
        p.name = "Hentai";
        p.atk = 10;
        p.def = 20;
        p.moveSpeed = 15.5f;
        p.roundSpeed = 15.6;
        p.weapon = new Item(1, 2);
        p.listInt = new List<int>() { 1, 2, 3, 4 };
        p.itemList = new List<Item>() { new Item(2, 5), new Item(3, 6) };
        p.itemDic = null;
        p.itemDic2 = new Dictionary<string, Item>() { { "1", new Item(6, 6) }, { "2", new Item(7, 10) } };
        SaveData(p, "playerInfo2");
        PlayerInfo p2 = LoadData("playerInfo2");
    }
    private void SaveData(PlayerInfo obj, string fileName)
    {
        string jsonStr = JsonMapper.ToJson(obj);
        File.WriteAllText(Application.persistentDataPath + "/" + fileName + ".json", jsonStr);
    }
    private PlayerInfo LoadData(string fileName) 
    {
        string jsonStr = File.ReadAllText(Application.persistentDataPath + "/" + fileName + ".json");
        return JsonMapper.ToObject<PlayerInfo>(jsonStr);
    }
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
