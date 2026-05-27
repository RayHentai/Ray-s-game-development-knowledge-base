# 05 XML 序列化和反序列化

**所属模块**：[[00 XML 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

> 序列化：把对象转化为可传输的字节序列过程称为序列化
   反序列化：把字节序列还原为对象的过程称为反序列化

**简单说：**
- 序列化就是把想要存储的内容转换为字节序列用于存储或传递
- 反序列化就是把存储或收到的字节序列信息解析读取出来使用

可以联想PlayerPrefs小项目的过程，就是在执行序列化和反序列化

---

## XML序列化

**注意：**
- 只能序列化公共成员
- 不支持字典序列化
- 可以通过特性修改节点信息 或者设置属性信息
- Stream相关 需要配合using使用

```csharp
public class Test
{
	public int testPublic = 10;
	private int testPrivate = 11;
	protected int testProtected = 12;
	internal int testInternal = 13;
	public string testPublicStr = "123";
	public int TesPro { get; set; }
	public Test2 testClass = new Test2();
	public int[] arratInt = new int[] {5, 6, 7};
	public List<int> listInt = new List<int>();
	public List<Test2> listItem = new List<Test2>() { new Test2(), new Test2() };
	public Dictionary<int, string> testDic = new Dictionary<int, string>() { { 1,"123" } };//会报错 这种序列化方式不支持字典
}
public class Test2
{
	public int test1 = 1;
	public float test2 = 1.1f;
	public bool test3 = true;
}
//1.第一步准备一个数据结构类
Test t = new Test();

//2.进行序列化 只能存公共成员变量
// XmlSerializer 用于序列化对象为xml的关键类
// Streamwriter 用于存储文件的流对象
// using 用于方便流对象释放和销毁
// 2.1 确定存储路径
string path = Application.persistentDataPath + "/Test.xml";
Test t = 
// 2.2 结合 Streamwriter流对象 和 using 写入对象
// 括号中的代码表示 写入一个文件流 如果有该文件 直接打开并修改 如果没有直接新建一个
// using () 括号中包裹的声明对象 会在大括号语句块结束后 自动释放
// 当语句块结束 会自动调用 对象的 Dispose 方法让其进行销毁
// using一般配合 内存占用打 或者有读写操作时使用的
using ( Streamwriter writer = new Streamwriter(path))
{
	// 2.3 进行xml文件序列化
	XmlSerializer s = new XmlSerializer(typeof(Test));
	//参数1 文件流对象
	//参数2 想要翻译的对象
	//注意：翻译机器的类型 一定要和传入对象的类型一致 不然会报错
	s.Serialize(writer, t);//通过序列化对象 对类对象进行翻译 将其翻译成xml格式 写入到对应的文件中
}
```

---

### 自定义节点名或属性名

> 可以通过特性 设置节点或者设置属性 并修改名字

```csharp
public class Test
{
	[XmlElement("想要修改的名字")]//修改元素名
	public int testPublic = 10;
	private int testPrivate = 11;
	protected int testProtected = 12;
	internal int testInternal = 13;
	public string testPublicStr = "123";
	public int TesPro { get; set; }
	public Test2 testClass = new Test2();
	public int[] arratInt = new int[] {5, 6, 7};
	[XmlArray("修改List的名字")]
	[XmlArrayItem("修改成员的名字")]
	public List<int> listInt = new List<int>() {1, 2, 3, 4};
	public List<Test2> listItem = new List<Test2>() { new Test2(), new Test2() };
}
public class Test2
{
	[XmlAttribute("这里可以修改名字")]//修改属性名
	public int test1 = 1;
	[XmlAttribute()]
	public float test2 = 1.1f;
	[XmlAttribute()]
	public bool test3 = true;
}
```

---

## 反序列化

**注意：如果List对象有默认值，反序列化时不会清空，会往后面添加**

```csharp
if (File.Exists(path)) //判断文件是否存在
{
	// using 和 StreamReader
	// XmlSerializer 的 Deserialize 反序列化方法
	//1 读取文件
	using (StreamReader reader = new StreamReader(path))
	{
		//2 产生序列化的翻译机器
		XmlSerializer s = new XmlSerializer(typeof(Test));
		Test t = s.Deserialize(reader) as Test;
	}
}
```

---

## IXmlSerializable 接口

- C#的 xmlSerializer 提供了可拓展内容
- 可以让一些不能被序列化和反序列化的特殊类能被处理
- 让特殊类继承 IXmlSerializable 接口实现其中的方法即可

**注意：序列化时如果引用类型成员变量是空，不会被写入xml中**

```csharp
public class Test : IXmlSerializable
{
	public int test1;
	public string test2;
	public XmlSchema GetSchema(){ return null; } //默认返回空就行
	public void ReadXml(XmlReader reader)//反序列化时会自动调用的方法
	{
		//自定义反序列化的规则
		//读属性
		test1 = int.Parse(reader["test1"]);
		test2 = reader["test2"];
		//读节点
		// 方法1
		reader.Read();//这时读到 test1 节点
		reader.Read();//这时读到 test1 节点包裹的内容
		test1 = int.Parse(reader.Value);//得到当前内容的值
		reader.Read();//这时读到 test1 尾部包裹节点
		reader.Read();//这时读到 test2 节点
		reader.Read();//这时读到 test2 包裹的节点
		test2 = reader.Value;
		// 方法2
		while (reader.Read())
		{
			if (reader.NodeType == XmlNodeType.Element)
			{
				switch(reader.Name)
				{
					case "test1":
						reader.Read();
						test1 = int.Parse(reader.Value);
						break;
					case "test2":
						reader.Read();
						test2 = reader.Value;
						break;
				}
			}
		}
		//读包裹节点
		XmlSerializer s = new XmlSerializer(typeof(int));
		XmlSerializer s2 = new XmlSerializer(typeof(string));
		reader.Read();//跳过根节点
		Reader.ReadStartElement("test1")
		test1 = (int)s.Deserialize(reader);
		Reader.ReadendElement()
		Reader.ReadStartElement("test2")
		test1 = (string)s.Deserialize(reader);
		Reader.ReadendElement()
	}
	public void WriteXml(XmlWriter writer)//序列化时自动调用的方法
	{
		//自定义序列化的规则
		//如果要自定义序列化的规则一定会用到 XmlWriter 中的一些方法来进行序列化
		//写属性
		writer.WriteAttributeString("test1", test1.ToString());
		writer.WriteAttributeString("test2", test2);
		//写节点
		writer.WriteElementString("test1", test1.ToString());
		writer.WriteElementString("test2", test2);
		//写包裹节点
		XmlSerializer s = new XmlSerializer(typeof(int));
		writer.WriteStartElement("test1");
		s.Serialize(writer, test1)
		writer.WriteEndElement();
		XmlSerializer s2 = new XmlSerializer(typeof(string));
		writer.WriteStartElement("test2");
		s.Serialize(writer, test2)
		writer.WriteEndElement();
	}
}

Test t = new Test();
using (Streamwriter writer = new Streamwriter(path))
{
	XmlSerializer s = new XmlSerializer(typeof(Test));
	s.Serialize(writer, t)
}
using (StreamReader reader = new StreamReader(path))
{
	XmlSerializer s = new XmlSerializer(typeof(Test));
	Test t = s.Deserialize(reader) as Test;
}
```

---

### 让Dictionary 支持xml序列化和反序列化

**思路：**
- c#自带的类不支持修改
- 可以重写一个类继承 `Dictionary`，实现里面的序列化和反序列化方法即可
- 然后让这个类继承序列化拓展接口 `IXmlSerializable`

**唯一缺点：读取和存储就只能用我们自己定义的，继承IXmlSerializable接口的Dictionary类作为成员变量。**

```csharp
public class SerizlizerDictionary<TKey, TValue> : Dictionary<TKey, TValue>, IXmlSerializable
{
	public XmlSchema GetSchema(){ return null; } //默认返回空就行
	//自定义 字典的 反序列化 规则
	public void ReadXml(XmlReader reader)
	{
		XmlSerializer keySer = new XmlSerializer(typeof(TKey));
		XmlSerializer valueSer = new XmlSerializer(typeof(TValue));
		reader.Read();
		//判断 当前不是这个元素节点结束就进行 反序列化
		while (reader.NodeType != XmlNodeType.EndElement)
		{
			TKey key = (TKey)keySer.Deserialize(reader);//反序列化键
			TValue value = (TValue)valueSer.Deserialize(reader);//反序列化值
			Add(key, value);//存储到字典中
		}
		reader.Read();//结束节点读取点
	}
	//自定义 字典的 序列化 规则
	public void WriteXml(XmlWriter writer)
	{
		XmlSerializer keySer = new XmlSerializer(typeof(TKey));
		XmlSerializer valueSer = new XmlSerializer(typeof(TValue));
		//遍历 存入
		foreach(KeyValuePair<TKey, TValue> kv in this)
		{
			keySer.Serialize(writer, kv.Key);
			valueSer.Serialize(writer, kv.Value);
		}
	}
}
```

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

---

## API 速查

- Streamwriter（类 存储文件的流对象）

- XmlSerializer（类 序列化对象）
	- XmlSerializer.Serialize（成员方法 将序列化对象翻译并写入文件）

- XmlElement 修改节点名
- XmlArray  修改包裹节点名名
- XmlArrayItem 修改包裹节点成员名
- XmlAttribute 转换成属性 也可以修改属性名
- XmlElement 修改元素名

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
