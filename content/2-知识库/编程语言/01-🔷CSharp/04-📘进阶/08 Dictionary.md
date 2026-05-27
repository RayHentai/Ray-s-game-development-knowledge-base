# 📖 08 Dictionary

**所属模块**：[[00 CSharp 进阶阶段总览]]
**关联**：[[04 Hashtable]] | [[16 List 排序]]
**查阅次数**：2

---

## 核心理解

> Dictionary<TKey, TValue> = 拥有泛型的 Hashtable，键值对从 object 变为可自己指定的泛型。

- 类型安全，是最常用的键值对容器。

---

## 声明

```csharp
using System.Collections.Generic;  // 需要引用此命名空间
// <键类型, 值类型>
Dictionary<int, string> dic = new Dictionary<int, string>();
```

---

## 增删查改

```csharp
// 增（不能出现相同键，会报错）
dic.Add(键, 值);

// 删
dic.Remove(键);
dic.Clear();

// 查
string val = dic[键]; // 通过键查值，找不到会直接报错（Hashtable 返回 null）
dic.ContainsKey(键); // 查看键是否存在 返回 bool
dic.ContainsValue(值); // 查看值是否存在 返回 bool

// 改
dic[键] = 新值;

// 长度
int count = dic.Count;
```

---

## 遍历

```csharp
// 遍历所有键
foreach (int key in dic.Keys)
    Console.WriteLine(key + " : " + dic[key]);

// 遍历所有值
foreach (string val in dic.Values)
    Console.WriteLine(val);

// 键值对一起遍历（变量类型用 KeyValuePair 结构体）
foreach (KeyValuePair<int, string> kv in dic)
    Console.WriteLine(kv.Key + " : " + kv.Value);
```

---

## 练习

> 1. 使用字典存储 0~9 的数字对应的大写文字，提示用户输入一个不超过三位的数，返回其大写形式（如 306 返回 叁零陆）

```csharp
public static string GetInfo(int input)
{
    string str = "";
    Dictionary<int, string> dic = new Dictionary<int, string>();
    dic.Add(0, "零"); 
    dic.Add(1, "壹"); 
    dic.Add(2, "贰"); 
    dic.Add(3, "叁");
    dic.Add(4, "肆"); 
    dic.Add(5, "伍"); 
    dic.Add(6, "陆"); 
    dic.Add(7, "柒");
    dic.Add(8, "捌"); 
    dic.Add(9, "玖");

    int b = input / 100;
    if (b != 0) 
	    str += dic[b];
    int s = input % 100 / 10;
    if (s != 0 || str != "") 
	    str += dic[s];
    int g = input % 10;
    str += dic[g];
    return str;
}

try
{
    Console.WriteLine("请输入一个不超过3位的数");
    Console.WriteLine(GetInfo(int.Parse(Console.ReadLine())));
}
catch { Console.WriteLine("请输入合法的数"); }
```

> 2. 计算 "Welcome to UnityWorld!" 中每个字出现的次数，用字典存储，不区分大小写

```csharp
Dictionary<char, int> dic1 = new Dictionary<char, int>();
string str = "WelcometoUnityWorld!";
str = str.ToLower();
for (int i = 0; i < str.Length; i++)
{
    if (str[i] == ' ') 
	    continue;
    if (dic1.ContainsKey(str[i])) 
	    dic1[str[i]] += 1;
    else                          
	    dic1.Add(str[i], 1);
}
foreach (char item in dic1.Keys)
    Console.WriteLine("字母{0}出现{1}次", item, dic1[item]);
```

---

## 我的踩坑记录

- 直接用 `dic[key]` 取不存在的键会抛异常，先用 `ContainsKey` 或 `TryGetValue`

---

*最后更新：*
