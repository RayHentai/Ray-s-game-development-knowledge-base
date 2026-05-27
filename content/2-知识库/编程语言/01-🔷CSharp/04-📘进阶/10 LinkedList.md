# 🔗 10 LinkedList

**所属模块**：[[00 CSharp 进阶阶段总览]]
**关联**：[[09 顺序存储与链式存储]] | [[11 泛型栈和队列]]
**查阅次数**：0

---

## 核心理解

> C# 封装好的类，本质是可变类型的泛型双向链表。
> 有两个类：`LinkedList<T>` 和 `LinkedListNode<T>`。

---

## 声明

```csharp
using System.Collections.Generic;  // 需要引用此命名空间
LinkedList<int> list = new LinkedList<int>();
```

---

## 增删查改

```csharp
// 增
LinkedList.AddFirst(元素); // 在链表头部添加
LinkedList.AddLast(元素); // 在链表尾部添加
LinkedList.AddAfter(节点, 值); // 往某个节点后面插入 节点可通过find找
LinkedList.AddBefore(节点, 值); // 往某个节点前面插入

// 删
LinkedList.RemoveFirst(); // 移除头节点
LinkedList.RemoveLast(); // 移除尾节点
LinkedList.Remove(元素); // 移除指定节点
LinkedList.Clear(); // 清空

// 查
LinkedListNode<int> first = LinkedList.First; // 头节点
LinkedListNode<int> last = LinkedList.Last; // 尾节点
LinkedList.Find(值); // 找到返回节点，没找到返回 null
LinkedList.Contains(值); // 返回 bool

// 改
LinkedList.First.Value = 值; // 先得到节点，再修改值

// 长度
int count = LinkedList.Count;

// 节点属性
node.Value; // 节点存储的值
node.Next; // 下一个节点
node.Previous; // 上一个节点
```

---

## 遍历

```csharp
// foreach（item 直接得到节点里面的值，不是节点）
foreach (int item in list)
    Console.WriteLine(item);

// 从头到尾
LinkedListNode<int> nowNode = LinkedList.First;
while (nowNode != null) 
{ 
	Console.WriteLine(nowNode.Value); 
	nowNode = nowNode.Next; 
}

// 从尾到头
nowNode = LinkedList.Last;
while (nowNode != null) 
{ 
	Console.WriteLine(nowNode.Value); 
	nowNode = nowNode.Previous; 
}
```

---

## 练习

> 1. 使用 LinkedList，向其中加入10个随机整形变量，正向遍历一次打印，反向遍历一次打印

```csharp
LinkedList<int> list = new LinkedList<int>();
Random r = new Random();
for (int i = 0; i < 10; i++)
    list.AddLast(r.Next(1, 100));

// 正向遍历
LinkedListNode<int> nowNode = list.First;
while (nowNode != null) 
{ 
	Console.WriteLine(nowNode.Value); 
	nowNode = nowNode.Next; 
}
Console.WriteLine("****************************");

// 反向遍历
nowNode = list.Last;
while (nowNode != null) 
{ 
	Console.WriteLine(nowNode.Value); 
	nowNode = nowNode.Previous; 
}
```

---

## 我的踩坑记录

- LinkedList 没有下标访问，只能通过遍历或节点引用访问

---

*最后更新：*
