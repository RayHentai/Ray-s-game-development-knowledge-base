# 📝 25 string 常用方法

**所属模块**：[[00 CSharp 核心阶段总览]]
**关联**：[[26 StringBuilder]]
**查阅次数**：0

---

## 核心理解

> **string 本质是 char 数组（字符数组）。**
> **string 很多方法不会改变原本 string 变量中的值，而是返回新字符串。**

注意：`String`中的索引器是只读的

---

## 字符串转为 char 数组 ToCharArray

```csharp
string s = "hello World"
char[] chars = s.ToCharArray();
chars[0] // 'h'
```

---

## 数组转 string
 
```csharp
string s = "123123123123";
string str = new string(s);
```

---

## 字符串拼接 Format

```csharp
string result = string.Format("{0}{1}...", 拼接内容, 拼接内容);
```

---

## 正向查找字符位置 IndexOf

>从正向开始查找，返回第一个匹配字符的索引值

```csharp
int idx = s.IndexOf(字符/字符串); // 没有找到返回 -1
```

---

## 反向查找字符位置 LastIndexOf

>从反向开始查找，返回第一个匹配字符的索引值

```csharp
int ridx = s.LastIndexOf(字符/字符串); // 没有找到返回 -1
```

---

## 移除指定位置后的字符 Remove

```csharp
s.Remove(指定位置); // 移除指定位置（包括）后的字符
s.Remove(开始位置, 字符个数); // 移除指定个数字符
```

---

## 替换指定字符串 Replace
 
```csharp
s.Replace(替换前字符串, 替换后的字符串);
```

---

## 大小写转换 ToUpper 和 ToLower
 
```csharp
s.ToUpper();  // 大写
s.ToLower();  // 小写
```

---

## 字符串截取 Substring
 
```csharp
s.Substring(索引); // 从索引到末尾
s.Substring(开始位置, 指定个数); // 截取指定个数字
```

---

## 字符串切割 Split
 
```csharp
string parts = "123"
string[] parts = s.Split(",");
//{ "1,","2,","3," }
```

---

## 练习

> 1. 请写出 string 中提供的截取和替换对应的函数名


- 截取：Substring(index) / Substring(index, count)
- 替换：Replace(oldValue, newValue)


> 2. 请将字符串 "1|2|3|4|5|6|7" 变为 "2|3|4|5|6|7|8" 并输出（使用字符串切割的方法）

```csharp
string str    = "1|2|3|4|5|6|7";
string[] strs = str.Split('|');
str = "";
for (int i = 0; i < strs.Length; i++)
{
    str += int.Parse(strs[i]) + 1;
    if (i != strs.Length - 1)
        str += "|";
}
Console.WriteLine(str);
```

> 3. String 和 string、Int32 和 int、Int16 和 short、Int64 和 long 他们的区别是什么？

后者是前者的别名，是一个关键字，两者完全等价。
- string = System.String
- int = System.Int32
- short = System.Int16
- long = System.Int64

> 4. 请问下面这段代码，分配了多少个新的堆空间？

```csharp
string str  = null; // 0 个（null 不分配堆空间）
str = "123"; // 1 个（新建字符串对象）
string str2 = str; // 0 个（str2 只是指向同一对象）
str2 = "321"; // 1 个（新建字符串对象）
str2 += "123"; // 1 个（字符串拼接产生新对象）
// 答：共分配了 3 个新的堆空间
```

> 5. 编写一个函数，将输入的字符串反转，不要使用中间商，必须原地修改输入数组，交换过程中不使用额外空间

```csharp
Console.WriteLine("请输入字符串");
string str = Console.ReadLine();
char[] chars = str.ToCharArray();
for (int i = 0; i < chars.Length / 2; i++)
{
    chars[i] = (char)(chars[i] + chars[chars.Length - i - 1]);
    chars[chars.Length - i - 1] = (char)(chars[i] - chars[chars.Length - i - 1]);
    chars[i] = (char)(chars[i] - chars[chars.Length - i - 1]);
}
Console.WriteLine(chars);
```

---

## 我的踩坑记录

- Substring 第二个参数是"字符个数"不是"结束索引"，经常搞混

---

*最后更新：*
