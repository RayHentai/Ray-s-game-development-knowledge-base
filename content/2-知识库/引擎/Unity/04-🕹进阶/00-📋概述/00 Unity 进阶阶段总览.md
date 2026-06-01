# Unity 进阶阶段总览

> **目标**：掌握 Unity 进阶常用系统——新输入系统、数据驱动的 ScriptableObject、高质量文本渲染、视频播放、以及资源动态加载（Addressables），能在项目中灵活选用并集成这些模块
> **前置**：[[00 Unity 核心阶段总览]]

---

## 知识点导航

> 按学习顺序排列，每个知识点独立一个文件

### Input System
- [[01 Input System 概述]]
- [[02 Input System 代码检测输入]]
- [[03 Input Action]]
- [[04 Input System 输入配置文件]]
- [[05 Player Input]]
- [[06 Player Input Manager]]
- [[07 Input System UGUI相关]]
- [[08 Input Debugger]]
- [[09 Input System 补充内容]]
- [[10 Input System 改键]]

### Scriptable Object
- [[11 Scriptable Object 概述]]
- [[12 Scriptabel Object 数据文件的创建和使用]]
- [[13 Scriptable Object 应用]]

### Text Mesh Pro
- [[14 Text Mesh Pro 概述]]
- [[15 Text Mesh Pro 文本]]
- [[16 Text Mesh Pro 字体资源]]
- [[19 Text Mesh Pro 预设]]
- [[20 Text Mesh Pro 基本设置]]
- [[21 Text Mesh Pro 材质球]]
- [[22 Text Mesh Pro 工具类]]

### 视频播放
- [[23 视频播放 概述]]
- [[24 视频格式和编解码器]]
- [[25 Unity中的视频兼容性]]
- [[26 视频剪辑设置]]
- [[27 Video Player 视频播放器]]
- [[28 全景视频]]

### Addressables
- [[29 Addressables 概述]]
- [[30 Addressables 寻址资源设置]]
- [[31 Addressables 指定资源加载]]
- [[32 Addressables 资源标签]]
- [[33 Addressables 动态加载资源]]
- [[34 Addressables Profiles 窗口]]
- [[35 Addressable中的配置文件]]
- [[36 Addressables Hosting 可寻址托管窗口配置]]
- [[37 Addressables 资源打包(发布)、加载]]
- [[38 Addressables 资源加载补充]]
- [[39 Addressables Debug相关]]
- [[40 Addressables 常用问题总结]]

---

## 📊 查阅次数统计

> **使用方法**：每次打开某个笔记查阅时，把下面对应的次数 +1。
> 次数越高 = 掌握越弱，重点复习这些。

| 序号 | 知识点 | 查阅次数 | 掌握程度 |
|------|--------|----------|----------|
| 01 | [[01 Input System 概述]] | 0 | ⬜⬜⬜⬜⬜ |
| 02 | [[02 Input System 代码检测输入]] | 0 | ⬜⬜⬜⬜⬜ |
| 03 | [[03 Input Action]] | 0 | ⬜⬜⬜⬜⬜ |
| 04 | [[04 Input System 输入配置文件]] | 0 | ⬜⬜⬜⬜⬜ |
| 05 | [[05 Player Input]] | 0 | ⬜⬜⬜⬜⬜ |
| 06 | [[06 Player Input Manager]] | 0 | ⬜⬜⬜⬜⬜ |
| 07 | [[07 Input System UGUI相关]] | 0 | ⬜⬜⬜⬜⬜ |
| 08 | [[08 Input Debugger]] | 0 | ⬜⬜⬜⬜⬜ |
| 09 | [[09 Input System 补充内容]] | 0 | ⬜⬜⬜⬜⬜ |
| 10 | [[10 Input System 改键]] | 0 | ⬜⬜⬜⬜⬜ |
| 11 | [[11 Scriptable Object 概述]] | 0 | ⬜⬜⬜⬜⬜ |
| 12 | [[12 Scriptabel Object 数据文件的创建和使用]] | 0 | ⬜⬜⬜⬜⬜ |
| 13 | [[13 Scriptable Object 应用]] | 0 | ⬜⬜⬜⬜⬜ |
| 14 | [[14 Text Mesh Pro 概述]] | 0 | ⬜⬜⬜⬜⬜ |
| 15 | [[15 Text Mesh Pro 文本]] | 0 | ⬜⬜⬜⬜⬜ |
| 16 | [[16 Text Mesh Pro 字体资源]] | 0 | ⬜⬜⬜⬜⬜ |
| 19 | [[19 Text Mesh Pro 预设]] | 0 | ⬜⬜⬜⬜⬜ |
| 20 | [[20 Text Mesh Pro 基本设置]] | 0 | ⬜⬜⬜⬜⬜ |
| 21 | [[21 Text Mesh Pro 材质球]] | 0 | ⬜⬜⬜⬜⬜ |
| 22 | [[22 Text Mesh Pro 工具类]] | 0 | ⬜⬜⬜⬜⬜ |
| 23 | [[23 视频播放 概述]] | 0 | ⬜⬜⬜⬜⬜ |
| 24 | [[24 视频格式和编解码器]] | 0 | ⬜⬜⬜⬜⬜ |
| 25 | [[25 Unity中的视频兼容性]] | 0 | ⬜⬜⬜⬜⬜ |
| 26 | [[26 视频剪辑设置]] | 0 | ⬜⬜⬜⬜⬜ |
| 27 | [[27 Video Player 视频播放器]] | 0 | ⬜⬜⬜⬜⬜ |
| 28 | [[28 全景视频]] | 0 | ⬜⬜⬜⬜⬜ |
| 29 | [[29 Addressables 概述]] | 0 | ⬜⬜⬜⬜⬜ |
| 30 | [[30 Addressables 寻址资源设置]] | 0 | ⬜⬜⬜⬜⬜ |
| 31 | [[31 Addressables 指定资源加载]] | 0 | ⬜⬜⬜⬜⬜ |
| 32 | [[32 Addressables 资源标签]] | 0 | ⬜⬜⬜⬜⬜ |
| 33 | [[33 Addressables 动态加载资源]] | 0 | ⬜⬜⬜⬜⬜ |
| 34 | [[34 Addressables Profiles 窗口]] | 0 | ⬜⬜⬜⬜⬜ |
| 35 | [[35 Addressable中的配置文件]] | 0 | ⬜⬜⬜⬜⬜ |
| 36 | [[36 Addressables Hosting 可寻址托管窗口配置]] | 0 | ⬜⬜⬜⬜⬜ |
| 37 | [[37 Addressables 资源打包(发布)、加载]] | 0 | ⬜⬜⬜⬜⬜ |
| 38 | [[38 Addressables 资源加载补充]] | 0 | ⬜⬜⬜⬜⬜ |
| 39 | [[39 Addressables Debug相关]] | 0 | ⬜⬜⬜⬜⬜ |
| 40 | [[40 Addressables 常用问题总结]] | 0 | ⬜⬜⬜⬜⬜ |

> **掌握程度**：
> ⬛⬛⬛⬛⬛ 完全掌握 / ⬛⬛⬛⬛⬜ 基本掌握 / ⬛⬛⬛⬜⬜ 大概了解 / ⬛⬛⬜⬜⬜ 有点模糊 / ⬛⬜⬜⬜⬜ 几乎不记得

---

## 🔗 知识点关联图

> 描述本阶段知识点之间的依赖关系，帮助理解学习顺序

```
Input Action → 输入配置文件 → Player Input → Player Input Manager
                                    ↓
                              UGUI相关 / 改键 / 补充内容

Scriptable Object 概述 → 数据文件创建 → 应用场景

Text Mesh Pro 概述 → 文本 / 字体资源 → 预设 → 基本设置 → 材质球 → 工具类

视频播放 概述 → 格式与编解码 → 兼容性 → 剪辑设置 → Video Player → 全景视频

Addressables 概述 → （热更新阶段展开）
```

---

## ✅ 阶段自检清单

> 学完本阶段后，逐条确认是否真正掌握

**Input System**
- [ ] 能说清楚新输入系统和旧 Input 的区别，知道为什么要换
- [ ] 能用 Input Action 配置多设备输入并绑定到 Player Input
- [ ] 能实现运行时改键并持久化保存

**Scriptable Object**
- [ ] 理解 SO 作为数据容器的优势，能对比 MonoBehaviour 说出区别
- [ ] 能创建 SO 数据文件并在多个 GameObject 之间共享数据

**Text Mesh Pro**
- [ ] 能生成自定义字体资源并处理中文乱码问题
- [ ] 能用 TMP 工具类实现富文本效果

**视频播放**
- [ ] 能配置 Video Player 播放本地和网络视频
- [ ] 了解不同平台的视频兼容性注意点

**综合能力**
- [ ] 能向别人解释本阶段各模块的核心概念和使用场景

---

## 🧠 本阶段核心概念速记

> 把本阶段最重要的概念用一句话概括，方便复习

| 概念 | 一句话理解 |
|------|-----------|
| Input Action | 将设备输入抽象为"动作"，与具体按键解耦，支持多设备切换 |
| Scriptable Object | Unity 的数据容器资产，不挂场景、跨对象共享、不随场景销毁 |
| Text Mesh Pro | 基于 SDF 字体渲染的高质量文本组件，替代旧版 Text |
| Video Player | Unity 内置视频播放组件，支持本地/URL 视频及渲染目标切换 |
| Addressables | 基于地址字符串的资源动态加载系统，是热更新的基础 |

---

## 📝 本阶段学习记录

**开始时间**：
**完成时间**：
**总耗时**：

**本阶段最难的知识点**：

**本阶段最有收获的地方**：

**遗留问题**（还没搞懂的）：
- 

---

## 🔄 复习计划

> 根据查阅次数统计，制定重点复习计划

**需要重点复习**（查阅次数 > 3）：
- 

**计划复习时间**：

---

*最后更新：2026-06-01*
