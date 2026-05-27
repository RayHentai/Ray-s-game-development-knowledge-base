# 🚶 03 Queue 队列

**所属模块**：[[00 CSharp 进阶阶段总览]]
**关联**：[[02 Stack 栈]] | [[11 泛型栈和队列]]
**查阅次数**：0

---

## 核心理解

> Queue = 先进先出（FIFO）的队列容器，本质是 object[] 数组的封装，封装了特殊的存储规则。

> 先存入的数据先获取，后存入的数据后获取。
> 适用存储消息通知。

**队列是先进先出**

---

## 声明

```csharp
using System.Collections;  // 需要引用此命名空间
Queue queue = new Queue();
```

---

## 增取查改

```csharp
// 增（入队）
queue.Enqueue(对象);

// 取（出队）
object first = queue.Dequeue(); // 取出队头并移除

// 查
object peek = queue.Peek(); // 查看队头，不移除
queue.Contains(对象); // 返回 bool

// 改
queue.Clear(); // 清空
```

---

## 遍历

```csharp
//队列元素数量
int count = queue.Count;

// foreach 遍历
foreach (object item in queue)
    Console.WriteLine(item);

// 转为数组再用 for 遍历
object[] arr = queue.ToArray();

// 循环出列
while (queue.Count > 0)
    Console.WriteLine(queue.Dequeue());
```

---

## 装箱拆箱

同 ArrayList，存值类型时存在装箱拆箱。

---

## 练习

> 1. 请简述队列的存储规则


先进先出（FIFO）。最先入队（Enqueue）的元素最先出队（Dequeue）。
适用场景：消息队列，有了就往里放，然后慢慢依次处理。


> 2. 使用队列存储消息，一次性存10条消息，每隔一段时间打印一条消息（控制台打印时要有明显停顿感）

```csharp
Queue queue = new Queue();
string str  = "你收到了一条新消息";
int index   = 0;
for (int i = 0; i < 9; i++)
    queue.Enqueue(str);

while (true)
{
    if (index % 700000000 == 0)
    {
        if (queue.Count > 0)
            Console.WriteLine(queue.Dequeue());
        index = 0;
    }
    ++index;
}
```

---

## 我的踩坑记录

- `Dequeue()` 会移除队头，`Peek()` 只是查看不移除

---

*最后更新：*
