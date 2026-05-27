# 🔢 16 List 排序

**所属模块**：[[00 CSharp 进阶阶段总览]]
**关联**：[[07 List]] | [[15 Lambda 表达式]]
**查阅次数**：0

---

## 核心理解

> `List.Sort()` 支持传入自定义比较函数，可以通过委托/匿名函数/Lambda 实现任意排序规则。

> 比较函数：返回正数 = 前者排后面，返回负数 = 前者排前面，返回 0 = 相等。

---

## 基本语法

```csharp
List<int> list = new List<int> { 3, 1, 4, 1, 5, 9 };

// 默认升序（要求元素实现 IComparable 接口）
list.Sort();

// 自定义排序（通过委托）
list.Sort((a, b) => a > b ? 1 : -1);   // 升序
list.Sort((a, b) => a > b ? -1 : 1);   // 降序

// 反转
list.Reverse();
```

^ba42bd

---

## 自定义类的排序

**注意：**
- IComparable 是一个接口 提供排序方法
- 升序降序 反转返回值的正负就行
- 继承 IComparable<类名> 接口 并实现 然后再执行Sort  不继承接口直接执行Sort会报错

```csharp
// 方式1：继承 IComparable<T> 接口（不继承直接执行 Sort 会报错）
class Monster : IComparable<Monster>
{
    public int atk;
    public int CompareTo(Monster other)
    {
	    if (this.atk > other.atk)
		    return 1;
		else
			return -1;
    }
}
list.Sort();

// 方式2：通过委托进行排序（更常用）
list.Sort(delegate (Monster a, Monster b) 
{
	if (a.atk > b.atk)
		return 1;
	else
		return -1;
);

// 方式3：用匿名函数/Lambda 一步到位
list.Sort(delegate(Monster a, Monster b) { return a.atk > b.atk ? 1 : -1; });
```

---

## 练习

> 1. 写一个怪物类（有攻击/防御/血量字段），创建10个怪物添加到 List，根据用户输入数字排序：1攻击排序、2防御排序、3血量排序、4反转

```csharp
class Monster
{
    public static int sortType = 1;
    public int atk, def, hp;
    private Random r = new Random();
    public Monster() 
    { 
	    atk = r.Next(1, 101); 
	    def = r.Next(1, 101); 
	    hp = r.Next(1, 101); 
    }
    public override string ToString() 
    { 
	    return string.Format("攻击力{0} 防御力{1} 血量{2}", atk, def, hp); 
    }
}

public static int SortFun(Monster m1, Monster m2)
{
    switch (Monster.sortType)
    {
        case 1: return m1.atk > m2.atk ? 1 : -1;
        case 2: return m1.def > m2.def ? 1 : -1;
        case 3: return m1.hp  > m2.hp  ? 1 : -1;
    }
    return 0;
}

Console.WriteLine("请输入数字进行排序\n1攻击排序\n2防御排序\n3血量排序\n4反转");
List<Monster> m = new List<Monster>();
for (int i = 0; i < 10; i++)
	m.Add(new Monster()); Console.WriteLine(m[i]); 
switch (Console.ReadLine())
{
    case "1": m.Sort((a, b) => a.atk > b.atk ? 1 : -1); 
	    break;
    case "2": m.Sort((a, b) => a.def > b.def ? 1 : -1); 
	    break;
    case "3": m.Sort((a, b) => a.hp  > b.hp  ? 1 : -1); 
	    break;
    case "4": m.Reverse(); 
	    break;
}
for (int i = 0; i < m.Count; i++) 
	Console.WriteLine(m[i]);
```

> 2. 写一个物品类（类型/品质/名字字段），创建10个物品添加到 List，同时使用类型、品质、名字长度进行排序，权重：类型>品质>名字长度

```csharp
List<Item> item = new List<Item>();
for (int i = 0; i < 10; i++) 
	item.Add(new Item()); Console.WriteLine(item[i]); 
item.Sort((Item a, Item b) =>
{
    if (a.type != b.type) 
	    return a.type > b.type ? -1 : 1;
    else if (a.pingZhi != b.pingZhi)  
	    return a.pingZhi > b.pingZhi ? -1 : 1;
    else 
	    return a.name.Length > b.name.Length ? -1 : 1;
});

Console.WriteLine("******************************");
for (int i = 0; i < 10; i++) 
	Console.WriteLine(item[i]);
```

> 3. 请尝试利用 List 排序方式对 Dictionary 中的内容排序（提示：得到 Dictionary 的所有键值对信息存入 List 中）

```csharp
Dictionary<int, string> dic = new Dictionary<int, string>();
dic.Add(7, "1234312"); 
dic.Add(3, "1234312"); 
dic.Add(4, "1234312");
dic.Add(1, "1234312"); 
dic.Add(5, "1234312"); 
dic.Add(2, "1234312"); 
dic.Add(6, "1234312");

List<KeyValuePair<int, string>> d = new List<KeyValuePair<int, string>>();
foreach (KeyValuePair<int, string> di in dic) 
	d.Add(di); Console.WriteLine(di.Key + "_" + di.Value); 
	
Console.WriteLine("******************************");
d.Sort((a, b) => a.Key > b.Key ? 1 : -1);
for (int i = 0; i < d.Count; i++) 
	Console.WriteLine(d[i].Key + "_" + d[i].Value);
```

---

## 我的踩坑记录

- 比较函数返回值：正数 = a 排在 b 后面，负数 = a 排在 b 前面

---

*最后更新：*
