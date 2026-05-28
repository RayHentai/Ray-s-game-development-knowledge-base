# 🏠 UI 知识库主页

> **这里是什么：** Unity UI 系统的完整笔记，覆盖 IMGUI（GUI）和 UGUI 两套系统。
> **怎么用：** 不知道用哪套系统看[[GUI vs UGUI 对比]]，找具体控件看[[UI控件速查]]。

---

## 📦 模块导航

| 模块             | 状态    | 核心内容                                                | 项目        |
| -------------- | ----- | --------------------------------------------------- | --------- |
| [[00 GUI 总览]]  | ✅ 已完成 | Label / Button / Toggle / Slider / Window / GUISkin | GUI封装与预设体 |
| [[00 UGUI 总览]] | ✅ 已完成 | Canvas / Image / Button / EventSystem / 图集 / 自动布局   | 登录选服UI    |

---

## 📊 整体进度

| 模块 | 知识点文件 | 完成情况 |
|------|-----------|---------|
| 01 GUI | 9个 | ⬛⬛⬛⬛⬛ 100% |
| 02 UGUI | 9个 | ⬛⬛⬛⬛⬛ 100% |

---

## 🛠️ 工具页

| 工具                 | 用途                          |
| ------------------ | --------------------------- |
| [[UI控件速查]]         | GUI / UGUI 所有控件一览，用途 + 所在文件 |
| [[GUI vs UGUI 对比]] | 两套系统适用场景、核心差异               |

---

## 🎯 学习目标

- [ ] 理解 GUI 和 UGUI 的本质区别，知道什么场景用哪个
- [ ] 能用 GUI 独立制作调试工具面板（不需要运行时美化）
- [ ] 能用 UGUI 制作完整的游戏 UI（主菜单、背包、对话框）
- [ ] 理解 Canvas 三种渲染模式的区别
- [ ] 会处理多分辨率适配（Canvas Scaler）
- [ ] 会用图集（Atlas）合并 Draw Call

---

## ✅ 自检清单

### GUI
- [ ] OnGUI 的执行时机（在哪个生命周期之后）
- [ ] Rect 坐标原点在左上角，和世界坐标不同
- [ ] GUIStyle vs GUISkin 的区别
- [ ] ModalWindow 的作用（阻断其他控件响应）
- [ ] `[ExecuteAlways]` 让 OnGUI 在编辑器下也执行

### UGUI
- [ ] Canvas 三种渲染模式：Screen Space Overlay / Camera / World Space
- [ ] Canvas Scaler 三种缩放模式
- [ ] EventSystem 的作用
- [ ] Image vs Raw Image 的区别
- [ ] Button / Toggle / Slider / InputField 的事件绑定方式
- [ ] 图集的作用（减少 Draw Call）
- [ ] 屏幕坐标转 UI 本地坐标（RectTransformUtility）
- [ ] Mask 遮罩的两种实现（Mask / RectMask2D）

---

## 📝 学习记录

**GUI 完成时间**：
**UGUI 完成时间**：

**最难的知识点**：

**遗留问题**：

---

*最后更新：*
