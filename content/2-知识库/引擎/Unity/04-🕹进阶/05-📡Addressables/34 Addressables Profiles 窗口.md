# 34 Addressables Profiles 窗口

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心理解

Profiles主要用于配置Addressable打包（构建）加载AB包时使用的一些变量
这些变量定义了
1. 在哪里保存打包（构建）的AB包
2. 运行时在哪里加载AB包

可以添加自定义变量，以便在打包加载时使用
之后在设置 组中打包和加载路径相关时，都是使用这里面的变量

**入口：**
方法一：Window > Asset Management > Addressables > Profiles
![[Profiles 入口1.png|465]]

方法二：在AddressableAssetSettings中打开
![[Profiles 入口2.png|664]]

方法三：在Addressables Groups窗口中打开
![[Profiles 入口3.png]]

---

## 窗口参数

![[Profiles 参数.png]]

---

## Profiles变量语法

所有的变量类型都是string字符串类型
可以在其中填写一些固定的路径或值来决定路径
还可以使用两个语法指示符让原本的静态属性变成动态属性

\[]:方括号，可以使用它包裹变量，在打包构建时会计算方括号包围的内容
比如
使用自己的变量\[BuildTarget]
使用别的脚本中变量\[UnityEditor.EditorUserBuildSettings.activeBuildTarget]
在打包构建时，会使用方括号内变量对应的字符串拼接到目录中

{}:大括号，可以使用它包裹变量，在运行时会计算大括号包围的内容
比如
使用别的脚本中变量{UnityEngine.AddressableAssets.Addressables.RuntimePath}

注意：方括号和大括号中使用的变量一定是静态变量或者属性。
名称、类型、命名空间必须匹配
比如在运行时 UnityEditor编辑器命名空间下的内容是不能使用的

---

## 什么时候用

> 适用场景，帮助建立使用直觉

- 场景一：
- 场景二：
- 反例（不该用的时候）：

---

## 注意事项 / 易错点

> ⚠️ 把容易踩的坑提前列出来

- 
- 

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
