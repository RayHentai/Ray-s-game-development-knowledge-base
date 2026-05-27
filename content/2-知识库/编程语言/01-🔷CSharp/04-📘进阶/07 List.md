# 📋 07 List

**所属模块**：[[00 CSharp 进阶阶段总览]]
**关联**：[[01 ArrayList]] | [[05 泛型]] | [[16 List 排序]]
**查阅次数**：0

---

## 核心理解

> `List<T>`是 C# 封装好的类，本质是可变类型的泛型数组，帮助我们实现了泛型的增删查改。

- 类型安全、无装箱拆箱，是最常用的动态数组，是 ArrayList 的泛型替代品。

---

## 声明

```csharp
using System.Collections.Generic;  // 需要引用此命名空间
List<int> intList = new List<int>();
List<string> stringList = new List<string>();
```

---

## 增删查改

```csharp
List<int> list = new List<int>();

// 增
list.Add(值);
list.AddRange(另一个集合);
list.Insert(插入位置, 插入值);

// 删
list.Remove(值); // 删除第一个匹配的元素
list.RemoveAt(下标);
list.Clear();

// 查
int val = list[0];
list.Contains(元素); // 查看元素是否存在，返回 bool
list.IndexOf(元素); // 正向查找，找到返回下标，找不到返回 -1
list.LastIndexOf(元素); // 反向查找，找到返回下标，找不到返回 -1

// 改
list[下标] = 值;

// 长度
int count = list.Count;
```

---

## 遍历

```csharp
List<int> = new list<int>() {1, 2, 3};
// for 循环
for (int i = 0; i < list.Count; i++)
    Console.WriteLine(list[i]);

// foreach 循环
foreach (int item in list)
    Console.WriteLine(item);
```

---

## List vs ArrayList

| 对比 | List<T> | ArrayList |
|------|---------|-----------|
| 类型安全 | ✅ 泛型，编译时检查 | ❌ object，运行时 |
| 装箱拆箱 | ❌ 无 | ✅ 存值类型时有 |
| 性能 | 更好 | 较差 |
| 推荐 | ✅ 优先使用 | ❌ 已基本被替代 |

---

## 练习

> 1. 请描述 List 和 ArrayList 的区别


- List 是一个可变类型的泛型数组，ArrayList 是一个 object 数组。
- List 类型安全、无装箱拆箱，性能更好，推荐优先使用。


> 2. 建立一个整形 List，为它添加 10~1，删除第5个元素，遍历剩余元素并打印

```csharp
List<int> array = new List<int>();
for (int i = 10; i > 0; i--)
    array.Add(i);
array.RemoveAt(4);
for (int i = 0; i < array.Count; i++)
    Console.WriteLine(array[i]);
```

> 3. 一个Monster基类，Boss和Gablin类继承它。在怪物类的构造函数中，将其存储到一个怪物List中。遍历列表可以让Boss和Gablin对象产生不同攻击 


```csharp
abstract class Monster
{
    public static List<Monster> monster = new List<Monster>();
    public Monster() 
    { 
	    monster.Add(this); 
    }
    public abstract void Atk();
}

class Boss : Monster 
{ 
	public override void Atk() 
	{ 
		Console.WriteLine("Boss攻击"); 
	} 
}
class Gablin : Monster 
{ 
	public override void Atk() 
	{ 
		Console.WriteLine("哥布林攻击"); 
	} 
}

Boss b = new Boss(); 
Gablin g = new Gablin(); 
Boss b1 = new Boss(); 
Gablin g1 = new Gablin();
for (int i = 0; i < Monster.monster.Count; i++)
    Monster.monster[i].Atk();
```

---

## 我的踩坑记录

- `RemoveAt(4)` 删的是下标4（第5个），不是值4

---

*最后更新：*
