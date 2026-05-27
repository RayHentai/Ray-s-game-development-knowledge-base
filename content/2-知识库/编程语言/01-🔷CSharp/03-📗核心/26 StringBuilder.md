# 🔤 26 StringBuilder

**所属模块**：[[00 CSharp 核心阶段总览]]
**关联**：[[25 string常用方法]]
**查阅次数**：0

---

## 定义

> C# 提供的一个用于处理字符串的公共类，修改字符串而不创建新的对象，提升性能。

---

## 初始化

```csharp
using System.Text;  // 需要引用命名空间

StringBuilder str = new StringBuilder(字符串);
StringBuilder str2 = new StringBuilder(字符串, 容量);  // 可不加容量
```

---

## 常用方法

```csharp
// 增加
变量名.Append(字符串); // 末尾追加               
变量名.AppendFormat("{0}{1}", 字符串, 字符串);// 拼接追加
变量名.Insert(插入位置, 字符串);// 插入
           
// 删除
变量名.Remove(删除位置, 删除个数);
变量名.Clear(); // 清空
  
// 查
变量名[索引]

// 改
变量名[索引] = 字符;// 直接修改某个字符           

// 替换
变量名.Replace(替换前的字符串, 替换后的字符串);

// 重新赋值
变量名.Clear();//先清除
变量名.Append(字符串);//再加入字符串

// 判断是否相等
变量名.Equals(字符串)
```

---

## 容量问题

- StringBuilder 存在容量问题，每次往里面增加时会自动扩容（**每次容量×2**）。
- 可以通过 `变量名.Capacity` 获取当前容量。

---

## string vs StringBuilder

| | string | StringBuilder |
|-|--------|--------------|
| 修改时 | 产生新对象（垃圾） | 原地修改，不产生垃圾 |
| 灵活性 | 方法更多更灵活 | 相对少一些 |
| 适用场景 | 少量修改/需要特殊方法 | 频繁拼接/修改 |

---

## 练习

> 1. 请描述 string 和 StringBuilder 的区别


string：
- 每次修改拼接都会产生垃圾，更加灵活，方法更多。
- 适用：少量修改，或需要用 string 特有方法的场景。

StringBuilder：
- 修改字符串不创建新对象，不产生垃圾，性能更好。
- 适用：需要频繁修改/拼接字符串的场景。


> 2. 如何优化内存


节约内存：少 new 新对象，少产生垃圾
尽力减少 GC：合理使用 static、string、StringBuilder
  - static：长期使用的对象用静态，避免反复创建
  - string：不要频繁拼接，改用 StringBuilder
  - StringBuilder：频繁修改字符串时使用

---

## 我的踩坑记录

- 忘记 `using System.Text`，找不到 StringBuilder

---

*最后更新：*
