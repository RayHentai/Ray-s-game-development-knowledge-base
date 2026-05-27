# 06 项目-XML 数据管理器

**所属阶段**：[[00 XML 总览]]
**综合知识点**：[[]] | [[]] | [[]]
**完成状态**：🔄 进行中 / ✅ 已完成
**查阅次数**：0

---

## 需求分析

> 目标：提供公共的序列化和反序列化方法给外部方便外部存储和获取微据

---

## 功能拆解

> 把整个项目拆成独立的功能模块，每个功能是一个可以单独实现的单元

- 存储对象的方法
- 读取对象的方法

---

## 完整工程

```csharp  title:Dictionary的处理
public class SerizlizerDictionary<TKey, TValue> : Dictionary<TKey, TValue>, IXmlSerializable
{
    public XmlSchema GetSchema()
    {
        return null;
    }

    public void ReadXml(XmlReader reader)
    {
        XmlSerializer keySer = new XmlSerializer(typeof(TKey));
        XmlSerializer ValueSer = new XmlSerializer(typeof(TValue));
        reader.Read();
        while (reader.NodeType != XmlNodeType.EndElement)
        {
            TKey key = (TKey)keySer.Deserialize(reader);
            TValue value = (TValue)ValueSer.Deserialize(reader);
            Add(key, value);
        }
        reader.Read();
    }

    public void WriteXml(XmlWriter writer)
    {
        XmlSerializer keySer = new XmlSerializer(typeof(TKey));
        XmlSerializer ValueSer = new XmlSerializer(typeof(TValue));
        foreach (KeyValuePair<TKey, TValue> kv in this)
        {
            keySer.Serialize(writer, kv.Key);
            ValueSer.Serialize(writer, kv.Value);
        }
    }
}
```

```csharp title:数据管理器
public class Xml_DataMgr
{
    private static Xml_DataMgr instance = new Xml_DataMgr();
    public static Xml_DataMgr Instance => instance;
    public void SaveData(object data, string fileName) 
    {
        string path = Application.persistentDataPath + "/" + fileName + ".xml";
        using (StreamWriter writer = new StreamWriter(path))
        {
            XmlSerializer s = new XmlSerializer(data.GetType());
            s.Serialize(writer, data);
        }
    }
    public object LoadData(Type type, string fileName)
    {
        string path = Application.persistentDataPath + "/" + fileName + ".xml";
        if (!File.Exists(path)) 
        {
            path = Application.streamingAssetsPath + "/" + fileName + ".xml";
            if (File.Exists(path)) 
            {
                Activator.CreateInstance(type);//如果实在找不到文件 就返回一个默认值的对象出去
            }
        }
        using (StreamReader reader = new StreamReader(path)) 
        {
            XmlSerializer s = new XmlSerializer(type);
            return s.Deserialize(reader);
        }
    }
}
```

```csharp title:测试
public class Xml_DataMgrTest_Item
{
    public int id = 1;
    public int num = 2;
}
public class Xml_DataMgrTest_Test
{
    public int i;
    public string str;
    public bool b;
    public int[] array;
    public List<int> listInt;
    public Xml_DataMgrTest_Item item;
    public List<Xml_DataMgrTest_Item> listItem;
    public SerizlizerDictionary<int, string> dic;
}
public class Xml_DataMgrTest : MonoBehaviour
{
    private void Start()
    {
        Xml_DataMgrTest_Test test = new Xml_DataMgrTest_Test();
        test.i = 1;
        test.str = "test";
        test.b = true;
        test.array = new int[] { 1, 2, 3 };
        test.listInt = new List<int>() { 1, 2, 3, 4 };
        test.item = new Xml_DataMgrTest_Item();
        test.listItem = new List<Xml_DataMgrTest_Item> { new Xml_DataMgrTest_Item(), new Xml_DataMgrTest_Item() };
        test.dic = new SerizlizerDictionary<int, string>() { { 1, "123" },{ 2, "13453" },{ 3, "124" } };
        Xml_DataMgr.Instance.SaveData(test, "TestFile");
        Xml_DataMgrTest_Test test2 = new Xml_DataMgrTest_Test();
        test2 = Xml_DataMgr.Instance.LoadData(typeof(Xml_DataMgrTest_Test), "TestFile") as Xml_DataMgrTest_Test;
    }
}
```

---

## 完成后的感悟

> 做这个项目学到了什么新东西？有没有对某个知识点有了新的理解？

**新学到的东西**：

**对某个知识点的新理解**：

**下次可以改进的地方**：

---

## 扩展想法

> 如果要继续优化这个项目，可以做哪些功能？

- 
- 

---

**完成时间**：
**耗时**：
