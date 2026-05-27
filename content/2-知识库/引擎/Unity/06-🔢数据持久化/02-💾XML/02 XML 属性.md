# 02 XML 属性

**所属模块**：[[00 XML 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

> 为节点添加属性信息

---

## 语法 / 用法

**注意：属性必须用引号包裹 单引号双引号都可以**

**属性和元素节点的区别：只是写法的区别**

```xml
<!--属性 空格 属性名=引号包裹的内容 空格...-->
<Friend name="小明" age='8'>我的朋友</Friend>
<!--如果使用属性记录信息 不想使用元素记录 可以如下这样写-->
<Father name="爸爸" age='50'/>

<Item>
	<id>1</id>
	<num>1</num>
</Item>
<!--也可以写为-->
<Item id="1" num = "1"/>
```



---

## 检查语法错误

**检查项：**
1. 元素标签必须配对
2. 属性必须有引号
3. 注意命名

直接复制到网页上进行验证
https://www.runoob.com/xml/xml-validator.html 

**注意：** 一般专门编辑xml的软件都会有判错功能

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

---

## 练习

> 1. 把下面的类翻译成xml

```csharp
public class Item
{
	public int id;
	public int num;
}
public class PlayerInfo
{
	public string name;
	public int atk;
	public int def;
	public float movespeed;
	public float roundspeed;
	public Item weapon;
	public List<int> ListInt;
	public List<Item> itemList;
	public Dictionary<int, Item> itemDic;
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<PlayerInfo>
	<!--自己定义一个xml 代表 类对象数据的规则
	元素节点名 就用变量名命名-->
	<name>Hentai</name>
	<atk>10</atk>
	<def>5</def>
	<moveSpeed>20</moveSpeed>
	<roundSpeed>60</roundSpeed>
	<weapon>
		<id>1</id>
		<num>1</num>
	</weapon>
	<!--出现没有变量名的数据 就用变量类型命名-->
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
		<Item>
			<int>1</int>
			<Item id="1" num="1"/>
			<int>2</int>
			<Item id="2" num="1"/>
			<int>3</int>
			<Item id="3" num="1"/>
		</Item>
	</itemDic>
</PlayerInfo>
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
