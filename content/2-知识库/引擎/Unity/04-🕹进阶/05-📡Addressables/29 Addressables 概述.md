# 29 Addressables 概述

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[01 AssetBundle]] | [[]]
**查阅次数**：0

---

## 核心理解

Addressables翻译过来是可寻址的意思，它是**可寻址资源管理系统**
是Unity从2018.2版本开始**建议用于替代AssetBundle的高阶资源管理系统**

在之后的Unity的新版本中，AssetBundle将渐渐被淘汰，但是AssetBundle还是必备的知识点
因为目前市面上还有很多的项目依旧在使用较老版本的Unity进行开发或者迭代，所以AssetBundle还是一种主流传统的资源管理方式

**Addressables和AssetBundle的主要作用是一样的**
1. 管理资源
2. 热更新
3. 减小包的体积

**Addressables是基于AssetBundle架构做的高阶流程**
![[Addressables 和 AssetBundle 的对比 图示.png|494]]

**Addressables的优点**
1. 自动化管理AB包打包、发布、加载
2. 可以更方便的进行本地、远程资源的加载
3. 系统会自动处理资源关联性
4. 内存管理更方便
5. 迭代更方便

---

## 导入 和 创建配置文件

**导入：windows -> Package -> Addressables**

**创建配置文件：**
**方法一：打开资源组窗口**
1. Window——>Asset Management——>Addressables——>Groups
2. 在窗口中点击 Create Addressables Settings按钮 创建配置文件
![[Addressables 创建配置文件 图示1.png|391]]


**方法二：在Inspector窗口中为资源勾选Addressable**
如果没有创建过配置相关文件，这时会自动创建相关文件
![[Addressables 创建配置文件 图示2.png|466]]

---

## 资源加载方式对比

**1. Resources**
特点：应用程序发布后不能动态修改、本地


**2. AssetBundle**
特点：减小包体大小、热更新

**3. Addressable**
特点：基于AssetBundle，帮助管理AssetBundle

Resources比较适用于做小游戏，单机游戏

AssetBundle和Addressables适合商业游戏具体AssetBundle和Addressables怎么选主要看团队和公司

如果是老项目或者迭代项目那么用以前写好的AssetBundle管理器即可，如果是新项目可以尝试使用Addressables，使用上更加方便





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
