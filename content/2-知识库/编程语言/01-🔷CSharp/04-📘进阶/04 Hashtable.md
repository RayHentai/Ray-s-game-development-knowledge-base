# 🗝️ 04 Hashtable

**所属模块**：[[00 CSharp 进阶阶段总览]]
**关联**：[[08 Dictionary]]
**查阅次数**：0

---

## 核心理解

> Hashtable = 又称散列表/哈希表，基于键的哈希代码组织起来的键值对容器。

> 键值一一对应，主要作用：提高数据查询效率，使用键来访问集合中的元素。
> 适用于存储拥有唯一 ID 的对象。

---

## 声明

```csharp
using System.Collections;  // 需要引用此命名空间
Hashtable hashtable = new Hashtable();
```

---

## 增删查改

```csharp
// 增（键值一起加，不能出现相同键，运行会报错）
hashtable.Add(键, 值);

// 删（只能通过键删除）
hashtable.Remove(键); // 删除不存在的键，没有反应
hashtable.Clear();

// 查（[] 里不是下标，是键）
object val = hashtable[键]; // 通过键查值，找不到返回 null
hashtable.Contains(键); // 等同于 ContainsKey
hashtable.ContainsKey(键); // 查看键是否存在
hashtable.ContainsValue(值); // 根据值检测

// 改（只能修改键对应的值，无法修改键）
hashtable[键] = 值;
```

---

## 遍历

> Count 是键值对数，所以 Hashtable 的遍历都用 foreach。

```csharp
// 遍历所有键（常用）
foreach (object key in hashtable.Keys)
    Console.WriteLine(key + " : " + hashtable[key]);

// 遍历所有值（常用）
foreach (object val in hashtable.Values)
    Console.WriteLine(val);

// 键值对一起遍历
foreach (DictionaryEntry entry in hashtable)
    Console.WriteLine(entry.Key + " : " + entry.Value);

//迭代器遍历
IDictionaryEnumerator myEnumerator = hashtable.GetEnumerator();
bool flag = myEnumerator.MoveNext();
while (flag)
{
	Console.WriteLine(myEnumerator.Key + ":" + myEnumerator.Value);
	flag = myEnumerator.MoveNext()
}
```

---

## 装箱拆箱

同 ArrayList，键和值都是 object，存取值类型时存在装箱拆箱。

---

## 练习

> 1. 请描述 Hashtable 的存储规则


- 一个键值对形式存储的容器，一个键对应一个值，类型是 object。
- 基于键的哈希代码组织，主要作用是提高数据查询效率。
- 键唯一，不能出现相同键，可以通过键快速访问对应的值。


> 2. 制作一个怪物管理器，提供创建怪物、移除怪物的方法，每个怪物都有自己的唯一 ID

```csharp
class MonsterMgr
{
    private static MonsterMgr instance = new MonsterMgr();
    Hashtable monster = new Hashtable();
    public static MonsterMgr Instance => instance;
    private MonsterMgr() { }
    private int monsterID = 0;

    public void Add()
    {
        Monster m = new Monster(monsterID);
        Console.WriteLine("添加了ID为{0}的怪物", monsterID);
        monster.Add(monsterID, m);
        ++monsterID;
    }

    public void Remove(int id)
    {
        if (monster.ContainsKey(id))
        {
            Console.WriteLine("移除了ID为{0}的怪物", id);
            monster.Remove(id);
        }
        else
            Console.WriteLine("找不到ID为{0}的怪物", id);
    }
}

class Monster 
{ 
	public int id; 
	public Monster(int id) 
	{ 
		this.id = id; 
	} 
}

MonsterMgr.Instance.Add();
MonsterMgr.Instance.Add();
MonsterMgr.Instance.Remove(999);
MonsterMgr.Instance.Remove(0);
```

---

## 我的踩坑记录

- Hashtable 遍历时不能同时修改集合，否则会抛异常

---

*最后更新：*
