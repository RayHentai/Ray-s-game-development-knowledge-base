# ⚖️ GUI vs UGUI 对比

> 一页搞清楚两套系统的区别，知道什么时候用哪个。

---

## 一句话区分

| | GUI（IMGUI）| UGUI |
|-|------------|------|
| **本质** | 每帧用代码重新绘制 | 场景中的 GameObject 组件 |
| **定位** | 调试工具 / 编辑器扩展 | **游戏内玩家 UI** |
| **能在编辑器里看到效果吗** | 需要运行才能看到 | ✅ 直接在 Scene 窗口预览 |

---

## 核心对比

| 对比项 | GUI | UGUI |
|--------|-----|------|
| **工作方式** | `OnGUI()` 每帧重绘，纯代码 | GameObject + 组件，可视化编辑 |
| **坐标原点** | 屏幕左上角 | 依赖 Anchor（锚点），相对父节点 |
| **分辨率适配** | ❌ 不支持，需自己算 | ✅ Canvas Scaler 自动适配 |
| **性能** | 较差（每帧重绘，产生GC）| 较好（只在变化时更新）|
| **美术参与** | ❌ 几乎不能，纯代码 | ✅ 可以，Inspector 直接调 |
| **动画支持** | ❌ 不支持 | ✅ Animator / Tween |
| **事件系统** | 简单（鼠标点击区域判断）| 完整（EventSystem / 接口 / Event Trigger）|
| **适合做** | 内部调试面板、编辑器工具 | 游戏 UI（菜单/背包/HUD）|

---

## 什么时候用 GUI

✅ **适合用 GUI 的场景：**
- 开发时的调试面板（实时显示角色状态、修改参数）
- 自定义 Editor 工具（在 Unity 编辑器中扩展功能）
- 快速原型验证（不在乎美观，只要能用）
- 用 `[ExecuteAlways]` 做编辑时预览的小工具

❌ **不适合用 GUI 的场景：**
- 玩家能看到的正式 UI
- 需要动画效果的 UI
- 多分辨率设备（手机/PC）都要适配的项目

---

## 什么时候用 UGUI

✅ **适合用 UGUI 的场景：**
- 主菜单、设置界面、登录界面
- 游戏内 HUD（血条、技能栏、小地图）
- 背包、商店、对话框
- 需要美术出图配合的 UI

---

## 关键概念对应关系

| GUI 概念 | UGUI 对应 |
|---------|----------|
| `Rect` 定位 | `Rect Transform` + Anchor 锚点 |
| `GUIStyle` | Inspector 里的组件属性 + 代码修改 |
| `GUISkin` | 统一的 UI 主题（目前 UGUI 没有内置，一般用 Theme / 自制工具 |
| `GUI.Label` | `Text` 组件 / `TextMeshPro` |
| `GUI.Button` | `Button` 组件 |
| `GUI.Toggle` | `Toggle` 组件 |
| `GUI.TextField` | `InputField` 组件 |
| `GUI.HorizontalSlider` | `Slider` 组件 |
| `GUI.DrawTexture` | `Image` 组件 / `Raw Image` 组件 |
| `GUI.BeginScrollView` | `Scroll View` 组件 |
| `GUI.Toolbar` / `SelectionGrid` | `Toggle Group` + 多个 `Toggle` |
| `GUI.ModalWindow` | 激活/失活 Panel + 设置最高 Sort Order |

---

## Canvas 三种渲染模式（UGUI 独有）

| 模式 | 含义 | 适用 |
|------|------|------|
| **Screen Space - Overlay** | UI 始终渲染在最上层，不受摄像机影响 | 大多数 2D HUD |
| **Screen Space - Camera** | UI 跟随指定摄像机，可被 3D 物体遮挡 | 需要 3D 效果的 UI |
| **World Space** | UI 作为场景中的 3D 物体存在 | 血条悬浮在角色头顶、3D 世界内的告示牌 |

---

## 关联

[[00 GUI 总览]] | [[00 UGUI 总览]] | [[UI控件速查]]

---

*最后更新：*
