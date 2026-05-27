# 01 Json基本语法

**所属模块**：[[00 Json 总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## Json文件相关

**启动Json文件：** 只要能打开文档的软件都能打开Json文件

**常用的一些打开Json文件的方式**
1. 系统自带 — 记事本、写字板
2. 通用文本编辑器 —— SublimeText等等
3. 网页Json编辑器

**创建Json文件：改文件后缀为.json 就可以**

**Json格式的结构：** 键值对结构
![[Json 文件结构.png]]

---

### Excel 转 Json

**配置Excel**

| id  | type | num | cd  | ids   | delay |
| --- | ---- | --- | --- | ----- | ----- |
| 1   | 1    | 5   | 0.8 | 1,10  | 8     |
| 2   | 2    | 5   | 0   | 11,20 | 10    |
| 3   | 2    | 8   | 0.5 | 1,20  | 5     |
| 4   | 1    | 10  | 0.5 | 5,15  | 10    |

**Excel数据转Json数据**
1. 搜索Excel转Json
2. 选择在线转换的网站 比如： https://www.bejson.com/json/col2json
3. 进行转换
4. 保存Json格式的数据

```json
[
{"id":1,"type":1,"num":5,"cd":0.8,"ids":"1,10","delay":8},
{"id":2,"type":2,"num":5,"cd":0,"ids":"11,20","delay":10},
{"id":3,"type":2,"num":8,"cd":0.5,"ids":"1,20","delay":5},
{"id":4,"type":1,"num":10,"cd":0.5,"ids":"5,15","delay":10}
]
```

---

## 注释

> 和CSharp中注释方式一致

```json
//注释内容
/*注释内容*/
```

---

## 语法规则

**注意事项：**
1. 如果数据表示对象那么最外层有大括号
2. 一定是键值对形式
3. 键一定是字符串格式
4. 键值对用逗号分开
5. 数组用`[]`包裹
6. 对象用`{}`包裹

**符号：**
```json
//符号含义：
{} -> 对象
[] -> 数组
: -> 键值对对应关系
, -> 数据分割
"" -> 键名/字符串

//键值对表示：
"键名":值内容
//值类型：数字(整数或浮点)、字符串、true或false、数组、对象、null
```

**Json数据和类对象的对应关系**

```csharp title:"csharp"
public class Teacher
{
	public string name;
	public int age;
	public bool sex;
	public List<int> ids;
	public List<Person> students;
	public Home home;
	public Person son;
	public Dictionary<int, string> dic;
}
public class Person
{
	public string name;
	public int age;
	public bool sex;
}
public class Home
{
	public string address;
	public string street;
}
```

```json title:"json"
{
	"name":"Hnetai",
	"age":18,
	"sex":true,
	"ids":[1,2,3,4,5,6],
	"student":[
		{"name":"小红", "age":16, "sex":true},
		{"name":"小明", "age":15, "sex":false},
	],
	"home":{"address":"武汉", "street":"硚口"},
	"son":null,
	//字典键会变成双引号 转换时要注意！！
	"dic":{"1":"123", "2":"234"}
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

> 1. 请用Json语法描述一个玩家信息类对象

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

```json
{
	"name":"Hentai",
	"atk":99,
	"def":50,
	"moveSpeed":15.4,
	"soundSpeed":43.4,
	"weapon":{"id":1, "num":10},
	"listInt":[1,2,3,4,5,6,7,8],
	"itemList":[{"id":1, "num":10},{"id":2, "num":5}],
	"itemDic":{"1":{"id":1, "num":10}, "2":{"id":2, "num":5}},
	"itemDic2":{"一":{"id":1, "num":10}, "二":{"id":2, "num":5}},
	"privateI":1,
	"protectedI":2
}
```

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
