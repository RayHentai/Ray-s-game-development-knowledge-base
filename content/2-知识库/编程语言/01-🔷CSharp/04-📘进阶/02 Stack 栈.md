# 📚 02 Stack 栈

**所属模块**：[[00 CSharp 进阶阶段总览]]
**关联**：[[03 Queue 队列]] | [[11 泛型栈和队列]]
**查阅次数**：0

---

## 核心理解

> Stack = 先进后出（LIFO）的栈容器，本质是 object[] 数组的封装，只是封装了特殊的存储规则。

> 先存入的数据后获取，后存入的数据先获取。
> 适用存储各种 UI 窗口对象。

**栈是先进后出**

---

## 声明

```csharp
using System.Collections;  // 需要引用此命名空间
Stack stack = new Stack();
```

---

## 增取查改

```csharp
// 增（压栈）
stack.Push(对象); // 由上至下，执行几次就增到第几层

// 取（弹栈）
object top = stack.Pop(); // 取出栈顶并移除

// 查（栈不能查看指定位置，只能查看栈顶）
object peek = stack.Peek(); // 查看栈顶，不移除
stack.Contains(对象); // 返回 bool

// 改（栈无法改变其中的元素，只能压和弹）
stack.Clear(); // 清空


```

---

## 遍历

>因为不能通过数组下标访问元素 所以只能通过foreach遍历

```csharp
//栈元素数量
int count = stack.Count;

//栈转数组
stack.ToArray();

// foreach 遍历（从栈顶开始）
foreach (object item in stack)
    Console.WriteLine(item);

// 转为数组再用 for 遍历（遍历顺序也是从栈顶开始）
object[] arr = stack.ToArray();
for (int i = 0; i < arr.Length; i++)
    Console.WriteLine(arr[i]);

// 循环弹栈（最常用）
while (stack.Count > 0)
    Console.WriteLine(stack.Pop());
```

---

## 装箱拆箱

同 ArrayList，存值类型时存在装箱拆箱。

---

## 练习

> 1. 请简述栈的存储规则

可以存任何对象，先进后出（LIFO）。
最后压入（Push）的元素最先弹出（Pop）。
栈不能查看指定位置的内容，只能查看栈顶（Peek）。
适用场景：UI 面板显隐规则、撤销操作历史等。

> 2. 写一个方法，计算任意一个数的二进制数（使用 Stack 实现）

```csharp
public static void Tool(int i)
{
    Console.Write("{0}的二进制是：", i);
    Stack stack = new Stack();
    while (true)
    {
        stack.Push(i % 2);
        i /= 2;
        if (i == 1) 
        { 
	        stack.Push(i); 
	        break; 
        }
    }
    while (stack.Count > 0)
        Console.Write(stack.Pop());
    Console.WriteLine();
}

Tool(10); Tool(2); Tool(3); Tool(8); Tool(16); Tool(9999);
```

---

## 我的踩坑记录

- `Pop()` 会移除栈顶，`Peek()` 只是查看不移除，用错会导致数据丢失

---

*最后更新：*
