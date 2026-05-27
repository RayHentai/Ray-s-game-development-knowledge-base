# 03 csharp读取XML文件

**所属模块**：[[00 XML 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## csharp读取xml的方法

- XmlDocument
  把数据加载到内存中，方便读取
- XmlTextReader
  以流形式加载，内存占用更少，但是是单向只读，使用不是特别方便，除非有特殊需求，否则不会使用
- Linq
  以后专门讲Linq的时候讲

**使用 `xmlDocument` 类读取是较方便最容易理解和操作的方法**

---

## 语法 / 用法

---

### 读取xml文件信息

```csharp
using System.Xml;
XmlDocument xml = new XmlDocument();
//有两个API
// 1.1 根据xml字符内容 加载xml文件
// 把存放在Resources文件下下的xml加载处理
TextAsset asset = Resources.Load<TextAsset>("XmlFileName");
//通过这个方法 翻译字符串为xml对象
xml.LoadXml(asset.text);

// 1.2 根据xml路径 加载xml文件
xml.Load(Application.streamingAssetsPath + "/XmlFileName.xml");
```

### 读取元素和属性信息

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Root>
	<name>user</name>
	<age>18</age>
	<Item id="1" num="10"/>
	<Friend>
		<name>小明</name>
		<age>8</age>
	</Friend>
	<Friend>
		<name>小红</name>
		<age>10</age>
	</Friend>
</Root>
```

```csharp
XmlDocument xml = new XmlDocument();
xml.Load(Application.streamingAssetsPath + "/XmlFileName.xml");
//1 XmlNode 同名时只能找到一个节点 不能获取同名节点
//获取根节点
XmlNode root = xml.SelectSingleNode("Root");
//通过根节点获取子节点
XmlNode nodeName = root.SelectSingleNode("name");
print(nodeName.InnerText); //18 获取节点元素 
//获取属性
XmlNode nodeItem = root.SelectSingleNode("Item");
//方法1
print(nodeItem.Attributes["id"].Value);//1
print(nodeItem.Attributes["num"].Value);//10
//方法2
print(nodeItem.Attributes.GetNamedItem("id").Value);//1

//2 XmlNodeList
//获取一个节点下 同名节点的方法
XmlNodeList friendList = root.SelectNodes("Friend");
//遍历方式1 迭代器
foreach (XmlNode item in friendList)
{
	print(item.SelectSingleNode("name").InnerText);
	print(item.SelectSingleNode("age").InnerText);
	//小明 8 小红10
}

//遍历方式2 for循环
for (int i = 0; i < friendList.Count; i++)
{
	print(friendList[i].SelectSingleNode("name").InnerText);
	print(friendList[i].SelectSingleNode("age").InnerText);
	//小明 8 小红10
}
```

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

---

## 练习

> 1. 有一个玩家数据类，请为该类写一个方法结合XML读取知识点将XML中数据读取到Playerlnfo的一个对象中

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlayerInfo>
	<name>Hentai</name>
	<atk>10</atk>
	<def>5</def>
	<moveSpeed>20</moveSpeed>
	<roundSpeed>60</roundSpeed>
	<weapon>
		<id>1</id>
		<num>1</num>
	</weapon>
	<ListInt>
		<int>1</int>
		<int>2</int>
		<int>3</int>
	</ListInt>
	<itemList>
		<Item id="1" num="10"/>
		<Item id="2" num="10"/>
		<Item id="3" num="10"/>
		<Item id="4" num="10"/>
		<Item id="5" num="10"/>
	</itemList>
	<itemDic>
		<int>1</int>
		<Item id="1" num="1"/>
		<int>2</int>
		<Item id="2" num="1"/>
		<int>3</int>
		<Item id="3" num="1"/>
	</itemDic>
</PlayerInfo>
```

```csharp
public class xml_Item
{
    public int id;
    public int num;
    public xml_Item() {}
}
[System.Serializable]
public class xml_PlayerInfo
{
    public string name;
    public int atk;
    public int def;
    public float moveSpeed;
    public float roundSpeed;
    public xml_Item weapon;
    public List<int> listInt;
    public List<xml_Item> itemList;
    public Dictionary<int, xml_Item> itemDic;

    public void LoadData()
    {
        XmlDocument xmlDocument = new XmlDocument();
        xmlDocument.LoadXml(Resources.Load<TextAsset>("TextXml").text);
        XmlNode nodePlayerInfo = xmlDocument.SelectSingleNode("PlayerInfo");
        name = nodePlayerInfo.SelectSingleNode("name").InnerText;
        atk = int.Parse(nodePlayerInfo.SelectSingleNode("atk").InnerText);
        def = int.Parse(nodePlayerInfo.SelectSingleNode("def").InnerText);
        moveSpeed = float.Parse(nodePlayerInfo.SelectSingleNode("moveSpeed").InnerText);
        roundSpeed = float.Parse(nodePlayerInfo.SelectSingleNode("roundSpeed").InnerText);
        XmlNode weaponNode = nodePlayerInfo.SelectSingleNode("weapon");
        weapon = new xml_Item();
        weapon.id = int.Parse(weaponNode.SelectSingleNode("id").InnerText);
        weapon.num = int.Parse(weaponNode.SelectSingleNode("num").InnerText);

        XmlNode listIntNode = nodePlayerInfo.SelectSingleNode("ListInt");
        XmlNodeList listIntNodes = listIntNode.SelectNodes("int");
        listInt = new List<int>(); 
        foreach (XmlNode item in listIntNodes)
        {
            listInt.Add(int.Parse(item.InnerText));
        }
        XmlNode listXmlItem = nodePlayerInfo.SelectSingleNode("itemList");
        XmlNodeList listXmlItems = listXmlItem.SelectNodes("Item");
        itemList = new List<xml_Item>();
        foreach (XmlNode item in listXmlItems)
        {
            xml_Item item2 = new xml_Item();
            item2.id = int.Parse(item.Attributes["id"].Value);
            item2.num = int.Parse(item.Attributes["num"].Value);
            itemList.Add(item2);
        }
        XmlNode itemDicNode = nodePlayerInfo.SelectSingleNode("itemDic");
        XmlNodeList itemDicInt = itemDicNode.SelectNodes("int");
        XmlNodeList itemDicItem = itemDicNode.SelectNodes("Item");
        itemDic = new Dictionary<int, xml_Item>();
        for (int i = 0; i < itemDicInt.Count; i++)
        {
            xml_Item item = new xml_Item();
            item.id = int.Parse(itemDicItem[i].Attributes["id"].Value);
            item.num = int.Parse(itemDicItem[i].Attributes["num"].Value);
            itemDic.Add(int.Parse(itemDicInt[i].InnerText), item);
        }
    }
}

public class xml_LoadMgr : MonoBehaviour
{

    public xml_PlayerInfo playerInfo;
    void Start()
    {
        playerInfo = new xml_PlayerInfo();
        playerInfo.LoadData();
    }
}
```

> 2. 练习题描述

```csharp
// 答案
```

---

## API 速查

- XmlDocument （类 XML文件）
	- XmlDocument.Load（成员方法 通过路径翻译xml）
	- XmlDocument.LoadXml（成员方法 通过asset翻译xml）

- XmlNode （类 节点）
	- XmlNode.SelectSingleNode（成员方法 获取节点）
	- XmlNode.SelectNodes （成员方法 获取全部节点）
	- XmlNode.Attributes.GetNamedItem（成员方法 得到元素和属性的键值对）
	- XmlNode.InnerText（成员属性 获得节点元素）
	- XmlNode.Attributes（成员索引器 得到元素和属性的键值对）

- XmlNodeList （类 节点数组）

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
