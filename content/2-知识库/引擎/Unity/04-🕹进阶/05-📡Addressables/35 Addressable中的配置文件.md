# 35 Addressable中的配置文件

**所属模块**：[[00 Unity 进阶阶段总览]]
**关联**：[[]] | [[]]
**查阅次数**：0

---

## 核心要点

**1. AddressableAssetSettings 可寻址资源设置**
就是对可寻址相关功能进行设置，较为重要的是
1. 概述配置——决定了路径配置相关
2. 诊断相关——决定了调试相关
3. 目录相关——决定目录后缀等内容
4. 内容更新相关——决定了更新相关方案
5. 构建和编辑器模式脚本相关——决定了测试方案
6. 资源组模板——决定了创建组时的配置模板

**2. Packed Assets**
Packed Assets 翻译过来的意思是 打包资产（资源）
它的作用是确定如何处理组中的资源
比如：可以指定生成AB包的位置和包压缩相关的等等设置

---

## 配置文件导航

在导入Addressables包之后 创建的那些就是配置文件
AddressableAssetsData文件夹下的内容都是本质为ScriptableObject的数据配置文件

可以在工程中对Addressables相关内容进行设置
他们会影响打包方式等等相关内容

AddressableAssetsData（可寻址资源数据）
- AssetGroups(资源组)
- 当创建一个组就会多一些相关数据配置文件
![[AddressableAssetsData 图示.png|560]]

AssetGroupTemplates（资源组模板，主要是对资源组的一些默认设置）
Packed Assets:打包资源数据配置
![[AssetGroupTemplates 图示.png|557]]

DataBuilders（数据生成器，这些内容决定了在不同模式下，资源打包和使用的方式）
BuildScriptFastMode:构建脚本快速模式
BuildScriptPackedMode:构建脚本打包模式
BuildScriptPackedPlayMode:构建脚本打包播放模式
BuildScriptVirtualMode:构建脚本虚拟模式
![[DataBuilders 图示.png|499]]

AddressableAssetSettings（可寻址资源设置）
DefaultObject（默认对象）
![[AddressableAssetSettings、DefaultObject 图示.png|483]]

---

## 配置文件

---

### Addressab Asset Settings

Addressab Asset Settings 翻译过来的意思就是 可寻址资源设置
该配置文件可以设置一些可寻址资源的一些公共设置

![[Profiles、Diagnostics、Catalog、Update a Previous Build、Downloads 参数.png]]
![[Build、Build and Play Mode Scripts、Asset Group Templates、Initialization Objects、Cloud Content Delivery 参数.png]]
![[Cache Initialization Setting 参数.png|717]]

---

### Packed Assets

Packed Assets 翻译过来的意思是 打包资产（资源）
它的作用是确定如何处理组中的资源
比如：可以指定生成AB包的位置和包压缩相关的等等设置

在Project窗口右键或者点击+号
Create(创建)——>Addressables(可寻址)——>Group Templates(组模板)——>Blank Group Template(空白组模板)

**Packed Assets**
![[Packed Assets 参数.png]]

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
