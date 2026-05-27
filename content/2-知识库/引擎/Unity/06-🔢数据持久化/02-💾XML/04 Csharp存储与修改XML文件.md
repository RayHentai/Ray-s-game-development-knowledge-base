# 04 Csharp存储与修改XML文件

**所属模块**：[[00 XML 总览]]
**关联**：[[03 csharp读取XML文件]] | [[]]
**查阅次数**：0

---

## 决定存储在哪个文件夹下

**注意：存储xml文件在Unity中一定是使用各平台都可读可写可找到的路径**

1. Resources 可读 不可写 打包后找不到 ❌
2. Application.streamingAssetsPath  可读 PC端可写 找得到 ❌
3. Application.dataPath 打包后找不到 ❌ 
4. Application.persistentDataPath 可读 可写 找得到  ✅

---

## 语法

> 展开讲解，可以分多个子章节

---

### 存储xml文件

```csharp
//关键类 xmlDocument 用于创建节点存储文件
//关键类 XmlDeclaration 用于添加版本信息
//关键类 XmlElement 节点类
string path = Application.persistentDataPath + "/xml文件名.xml";

//存储有5步
//1 创建文本对象
XmlDocument xml = new xmlDocument();

//2 添加固定版本信息
XmlDeclaration xmlDec = xml.CreateXmlDeclaration("1.0", "UTF-8", "");//创建内容
xml.AppendChild(xmlDec);//添加进文本对象中

//3 添加根节点
XmlElement root = xml.CreateElement("节点名");
xml.AppendChild(root);

//4 为根节点添加子节点
XmlElement name = xml.CreateElement("节点名");
name.InnerText = "Hentai";
root.AppendChild(name);

XmlElement listInt = xml.CreateElement("listInt");//为根节点的子节点添加子节点
root.AppendChild(listInt);
for (int i = 1; i <= 3; i++)
{
	XmlElement intNode = xml.CreateElement("int");
	intNode.InnerText = "10";
	listInt.AppendChild(intNode);
}

XmlElement itemList = xml.CreateElement("itemList");//为根节点的子节点添加子节点添加属性
root.AppendChild(itemList);

for (int i = 1; i <= 3; i++)
{
	XmlElement itemNode = xml.CreateElement("Item");
	itemNode.SetAttribute("id", i.ToString());//添加属性
	itemNode.SetAttribute("num", (i * 10).ToString());
	listInt.AppendChild(itemNode);
}

//5 保存
xml.Save(path);
```
 
### 修改xml文件

```csharp
//1 判断文件存不存在
if (File.Exists(path))
{
	//2 加载后 直接添加节点 移除节点即可
	//读取文件
	xmlDocument newXml = new xmlDocument();
	newXml.load(path);
	//修改 就是在原有文件基础上去移除或者添加
	//移除
	XmlNode node = newXml.SelectsingleNode("Root").SelectsingleNode("atk");
	node = newXml.SelectSingleNode("Root/atk");//和上面一样 更方便
	//移除 先得到root
	XmlNode root = newXml.SelectsingleNode("Root");
	root.RemoveChild(node);
	//添加节点
	XmlElement speed = newXml.CreateElement("moveSpeed");
	speed.InnerText = "20";
	//保存
	newXml.Save(path);
}

```

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

---

## 练习

> 1. 结合上一个知识点的练习题，实现将Playerlnfo数据存储到XML文件

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

    public void LoadData(string fileName)
    {
        //如果可读可写中从来没有存储过 是不存在这个文件的
        //那么读取时就先从默认文件中获取内容
        string path = Application.persistentDataPath + "/" + fileName + ".xml";
        if (!File.Exists(path))
        {
            path = Application.streamingAssetsPath + "/" + fileName + ".xml";
        }
        XmlDocument xmlDocument = new XmlDocument();
        xmlDocument.LoadXml(Resources.Load<TextAsset>(fileName).text);
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
    public void SaveDate(string fileName)
    {
        string path = Application.persistentDataPath + "/" + fileName + ".xml";
        XmlDocument xml = new XmlDocument();
        XmlDeclaration xmlDec = xml.CreateXmlDeclaration("1.0", "UTF-8", "");
        xml.AppendChild(xmlDec);
        XmlElement root = xml.CreateElement("PlayerInfo");
        xml.AppendChild(root);
        XmlElement name = xml.CreateElement("name");
        name.InnerText = this.name;
        root.AppendChild(name);
        XmlElement atk = xml.CreateElement("atk");
        atk.InnerText = this.atk.ToString();
        root.AppendChild(atk);
        XmlElement def = xml.CreateElement("def");
        def.InnerText = this.def.ToString();
        root.AppendChild(def);
        XmlElement moveSpeed = xml.CreateElement("moveSpeed");
        moveSpeed.InnerText = this.moveSpeed.ToString();
        root.AppendChild(moveSpeed);
        XmlElement roundSpeed = xml.CreateElement("roundSpeed");
        roundSpeed.InnerText = this.roundSpeed.ToString();
        root.AppendChild(roundSpeed);
        XmlElement weapon = xml.CreateElement("weapon");
        root.AppendChild(roundSpeed);
        XmlElement weaponId = xml.CreateElement("id");
        weaponId.InnerText = this.weapon.id.ToString();
        weapon.AppendChild(weaponId);
        XmlElement weaponNum = xml.CreateElement("num");
        weaponNum.InnerText = this.weapon.id.ToString();
        weapon.AppendChild(weaponNum);
        XmlElement listInt = xml.CreateElement("listInt");
        root.AppendChild(listInt);
        for (int i = 0; i < this.listInt.Count; i++)
        {
            XmlElement ints = xml.CreateElement("int");
            ints.InnerText = this.listInt[i].ToString();
            listInt.AppendChild(ints);
        }
        XmlElement itemList = xml.CreateElement("itemList");
        root.AppendChild(itemList);
        for (int i = 0; i < this.itemList.Count; i++)
        {
            XmlElement item = xml.CreateElement("item");
            item.SetAttribute("id", this.itemList[i].id.ToString());
            item.SetAttribute("num", this.itemList[i].num.ToString());
            itemList.AppendChild(item);
        }
        XmlElement itemDic = xml.CreateElement("itemDic");
        root.AppendChild(itemDic);
        foreach (int key in this.itemDic.Keys)
        {
            XmlElement dicInt = xml.CreateElement("int");
            dicInt.InnerText = key.ToString();
            itemDic.AppendChild(dicInt);
            XmlElement dicItem = xml.CreateElement("item");
            dicItem.SetAttribute("id", this.itemDic[key].id.ToString());
            dicItem.SetAttribute("num", this.itemDic[key].num.ToString());
            itemDic.AppendChild(dicItem);
        }
        xml.Save(path);
    }
}
```

---

## API 速查

- XmlDocument（类 XML存储文件）
	- XmlDocument.CreateElement（成员方法 创建新节点）
	- XmlDocument.CreateXmlDeclaration（成员方法 添加固定内容）
	- XmlDocument.AppendChild（成员方法 添加根节点）
	- XmlDocument.Save （方法 存储到本地）

- XmlDeclaration（类 版本信息）

- XmlElement（类 节点）	
	- XmlElement.SetAttribute（成员方法 添加属性）
	- XmlElement.AppendChild（成员方法 添加子节点）
	- XmlElement.InnerText（成员属性 节点元素）

- File（类 文件）
	- File.Exists （方法 判断文件是否存在）

- XmlNode（类 节点）
	- XmlNode.RemoveChild （成员方法 移除节点）
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
