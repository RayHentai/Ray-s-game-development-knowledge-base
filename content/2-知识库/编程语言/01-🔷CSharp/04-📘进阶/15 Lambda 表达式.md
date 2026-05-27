# ⚡ 15 Lambda 表达式

**所属模块**：[[00 CSharp 进阶阶段总览]]
**关联**：[[14 匿名函数]] | [[16 List 排序]]
**查阅次数**：0

---

## 核心理解

> Lambda = 匿名函数的简写，用 `=>` 符号，使用上和匿名函数一样，都配合委托和事件使用。

---

## 语法

```csharp
// delegate => { 函数体 };

// 无参无返回值
Action action = () => { Console.WriteLine("Hello"); };

// 有参（参数类型和委托一致时可以省略参数类型）
Action<int> a2 = (int value) => { Console.WriteLine(value); };
Action<int> a3 = (value) => { Console.WriteLine(value); };  // 省略参数类型

// 有返回值
Func<int, string> func = (value) => { return value.ToString(); };
```

---

## 闭包

> 内层的函数可以引用包含在它外层的函数的变量，即使外层函数的执行已经终止。

```csharp
// 注意：改变了提供的值，并非创建时的值，而是在父函数范围内的最终值
Action action = null;
for (int i = 0; i < 10; i++)
{
    action += () => { Console.WriteLine(i); };  // 打印出来的全是 10！
}
action();

// 正确写法：在循环内声明新变量，重新赋值
for (int i = 0; i < 10; i++)
{
    int index = i;  // 关键：创建副本
    action += () => { Console.WriteLine(index); };  // 正确打印 0~9
}
```

---

## Lambda 内部可以继续封装函数

```csharp
Action<int> action = (value) =>
{
    void Inner() { Console.WriteLine(value); }
    Inner();
};
```

---

## 练习

> 1. 有一个函数，会返回一个委托函数，这个委托函数中只有一句打印代码；之后执行返回的委托函数时，可以打印出 1~10

```csharp
public static Action Test()
{
    Action action = null;
    for (int i = 1; i <= 10; i++)
    {
        int index = i; // 创建副本，避免闭包陷阱
        action += () => { Console.WriteLine(index); };
    }
    return action;
}

Test()();  // 打印 1~10
```

---

## 我的踩坑记录

- 循环里用 Lambda 捕获变量时，必须在循环内用 `int index = i` 创建副本，否则所有 Lambda 都捕获最终值

---

*最后更新：*
