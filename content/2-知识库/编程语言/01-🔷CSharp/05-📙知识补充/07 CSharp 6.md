# 07 C# 6

**所属模块**：[[00 CSharp 知识补充总览]]
**关联**：[[10 异常捕获]] | [[23 特殊语法补充]]
**查阅次数**：0

---

## 新功能和语法

1. =>运算符（特殊语法 =>）
2. Null 传播器（特殊语法 ?）
3. 字符串内插（特殊语法 $）
4. 静态导入
5. 异常筛选器
6. nameof运算符

**C#6中的新内容**
 - =>运算符、Null传播器、字符串内插是常用的
- 其它补充的几个知识点使用情景不多，了解即可

---

### 静态导入

**用法：** 在引用命名空间时，在using关键字后面加入static关键词
**作用：** 无需指定类型名称即可访问其静态成员和嵌套类型
**好处：** 节约代码量，可以写出更简洁的代码

```csharp
using static UnityEngine.Mathf;
using static Test3;

public class Test3
{
    public class Test4 { }
    public static void TTT() { Debug.Log("123"); }
}
//Mathf.Max(10, 20); 常规写法
Max(10, 20);
TTT();
Test4 t = new Test4();
```

---

### 异常筛选器

**用法：** 在异常捕获语句块中的Catch语句后通过加入when关键词来筛选异常
- when（表达式）该表达式返回值必须为bool值，如果为ture则执行异常处理，如果为false，则不执行
**作用：** 用于筛选异常
**好处：** 帮助我们更准确的排查异常，根据异常类型进行对应的处理

```csharp
try
{
    //用于检查异常的语句块
}
catch (System.Exception e) when(e.Message.Contains("301")) //错误编号
{
    //当错误编号为301时  作什么处理
    print(e.Message);
}
catch (System.Exception e) when (e.Message.Contains("404"))
{
    //当错误编号为404时  作什么处理
    print(e.Message);
}
catch (System.Exception e) when (e.Message.Contains("21"))
{
    //当错误编号为21时  作什么处理
    print(e.Message);
}
catch (System.Exception e)
{
    //当错误编号为其它时  作什么处理
    print(e.Message);
}
```

---

### nameof运算符

**用法：** nameof(变量、类型、成员)通过该表达式，可以将他们的名称转为字符串
**作用：** 可以得到变量、类、函数等信息的具体字符串名称

```csharp
int i = 10;
print(nameof(i));//i

print(nameof(List<int>));//List
print(nameof(List<int>.Add));//Add

print(nameof(UnityEngine.AI));//AI

List<int> list = new List<int>() { 1,2,3,4};
print(nameof(list));//list
print(nameof(list.Count));//Count
print(nameof(list.Add));//Add
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
