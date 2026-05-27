# CSharp版本和Unity的关系

**所属模块**：[[00 CSharp 知识补充总览]]
**关联**：[[05 CSharp 1~4]] | [[06 CSharp 5]] | [[07 CSharp 6]] | [[08 CSharp 7]] | [[09 CSharp 8]]
**查阅次数**：0

---

## 版本对应关系

Unity 2021.2 —— C# 9
Unity 2020.3 —— C# 8
Unity 2019.4 —— C# 7.3
Unity 2017   —— C# 6
Unity 5.5    —— C# 4

更多信息可以在Untiy官网说明查看
https://docs.unity3d.com/2020.3/Documentation/Manual/CSharpCompiler.html

不同Unity版本支持的C#版本不同
主要是不同Unity版本 使用的 C#编译器和脚本运行时版本不同

比如：Unity2020.3 使用的脚本运行时版本等效于.Net 4.6，编译器为Roslyn（罗斯林编译器）
所以随着Unity的更新，它一般会采用较新的 编译器和运行时版本
新版本的脚本运行时将为Unity带来了大量的新版C#功能和.NET的功能
也就意味着它可以支持更高版本的C#

可以根据不同Unity支持的对应C#版本
来判断我们是否可以使用C#各版本中的一些新功能用来编程
虽然即使我们没有掌握这些功能也能正常进行开发
但是往往新功能可以让我们写出更简单明了的代码
可以节约代码量


---

## Unity的.Net API兼容级别

在PlayerSetting->Other Setting->Api Compatibility Level中
我们可以设置.Net API的兼容级别
主要有两种选择
.Net 4.x（特殊需求时）:
具备较为完整的.Net API，甚至包含了一些无法跨平台的API
如果你的应用主要针对Windows平台，并且会使用到.Net Standard 2.0中没有的功能时
会选择使用它

.Net Standard 2.0（建议使用）:
是一个.Net标准API集合，相对.Net 4.x包含更少的内容，可以减小最终可执行文件大小
它具有更好的跨平台支持

.Net Standard 2.0 配置文件大小是.Net 4.x配置文件的一半
所以我们尽量使用.Net Standard 2.0

---

## 总结

由于新版本Unity会同时更新
Scripting Runtime(脚本运行时)和 C#编译器的版本
所以随着Unity版本的提升
能够使用到的C#的新功能和新特性也会增加

要大概了解自己正在使用的Unity版本能够支持的C#版本
这样在开发时我们就能使用一些对应版本的新功能和特性了
Unity 2021.2 —— C# 9
Unity 2020.3 —— C# 8
Unity 2019.4 —— C# 7.3
Unity 2017   —— C# 6
Unity 5.5    —— C# 4

并且，对于.Net API兼容级别的认识是
正常情况下 我们都会使用.Net Standard

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
