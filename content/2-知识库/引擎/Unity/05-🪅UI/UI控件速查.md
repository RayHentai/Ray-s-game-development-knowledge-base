# 🎛️ UI 控件速查

> GUI 和 UGUI 所有控件一览。找到控件名 → 看用途 → 跳转到对应文件。

---

## GUI 控件

> GUI 控件都写在 `OnGUI()` 函数里，坐标原点在**屏幕左上角**，用 `Rect(x, y, w, h)` 定位。

| 控件       | 方法                                               | 用途                        | 返回值             | 所在文件            |
| -------- | ------------------------------------------------ | ------------------------- | --------------- | --------------- |
| **文本**   | `GUI.Label(rect, "文字")`                          | 显示静态文字或图片，不可交互            | 无               | [[02 文本与按钮控件]]  |
| **普通按钮** | `GUI.Button(rect, "文字")`                         | 点击触发（按下+抬起才算一次）           | `bool`          | [[02 文本与按钮控件]]  |
| **长按按钮** | `GUI.RepeatButton(rect, "文字")`                   | 持续按住持续触发                  | `bool`          | [[02 文本与按钮控件]]  |
| **多选框**  | `GUI.Toggle(rect, bool, "文字")`                   | 勾选/取消勾选                   | `bool`          | [[03 多选框与单选框]]  |
| **单选框**  | `GUI.Toggle` + int 索引                            | 多个 Toggle 共用一个 int，值相等即选中 | `bool`          | [[03 多选框与单选框]]  |
| **输入框**  | `GUI.TextField(rect, string)`                    | 普通文本输入                    | `string`        | [[04 输入框与拖动条]]  |
| **密码框**  | `GUI.PasswordField(rect, string, '*')`           | 输入内容显示为遮罩字符               | `string`        | [[04 输入框与拖动条]]  |
| **水平滑条** | `GUI.HorizontalSlider(rect, value, min, max)`    | 水平拖动条                     | `float`         | [[04 输入框与拖动条]]  |
| **垂直滑条** | `GUI.VerticalSlider(rect, value, min, max)`      | 竖直拖动条                     | `float`         | [[04 输入框与拖动条]]  |
| **图片**   | `GUI.DrawTexture(rect, texture, scaleMode)`      | 绘制贴图，支持三种缩放模式             | 无               | [[05 图片绘制与框]]   |
| **框**    | `GUI.Box(rect, "文字")`                            | 带边框的容器，可放文字/图片            | 无               | [[05 图片绘制与框]]   |
| **工具栏**  | `GUI.Toolbar(rect, int, string[])`               | 横排页签，返回当前选中索引             | `int`           | [[06 工具栏与选择网格]] |
| **选择网格** | `GUI.SelectionGrid(rect, int, string[], xCount)` | 多行网格页签                    | `int`           | [[06 工具栏与选择网格]] |
| **分组**   | `GUI.BeginGroup(rect)` / `EndGroup()`            | 给控件加"父对象"，统一偏移坐标          | 无               | [[07 滚动视图与分组]]  |
| **滚动视图** | `GUI.BeginScrollView(...)` / `EndScrollView()`   | 可滚动的内容区域                  | `Vector2`（滚动位置） | [[07 滚动视图与分组]]  |
| **普通窗口** | `GUI.Window(id, rect, 函数, "标题")`                 | 可包含其他控件的浮动窗口              | `Rect`          | [[08 窗口]]       |
| **模态窗口** | `GUI.ModalWindow(id, rect, 函数, "标题")`            | 弹出后屏蔽其他所有控件响应             | `Rect`          | [[08 窗口]]       |
| **窗口拖拽** | `GUI.DragWindow()`                               | 写在 Window 函数内，使窗口可拖动      | 无               | [[08 窗口]]       |

### GUI 样式系统

| 名称                    | 作用              | 所在文件           |
| --------------------- | --------------- | -------------- |
| `GUI.color`           | 全局颜色，影响所有后续控件   | [[09 自定义整体样式]] |
| `GUI.contentColor`    | 全局文字颜色          | [[09 自定义整体样式]] |
| `GUI.backgroundColor` | 全局背景颜色          | [[09 自定义整体样式]] |
| `GUIStyle`            | 单个控件的自定义外观      | [[09 自定义整体样式]] |
| `GUISkin`             | 批量自定义所有控件外观（皮肤） | [[09 自定义整体样式]] |

---

## UGUI 控件

> UGUI 控件都是 **组件**，挂在 GameObject 上，通过 Inspector 配置或代码获取引用后操作。

### 基础组件（画布层）

| 组件                          | 作用                                   | 所在文件          |
| --------------------------- | ------------------------------------ | ------------- |
| **Canvas**                  | UI 的根容器，控制渲染模式（Overlay/Camera/World） | [[01 六大基础组件]] |
| **Canvas Scaler**           | 分辨率自适应，三种缩放模式                        | [[01 六大基础组件]] |
| **Graphic Raycaster**       | 射线检测，让 Canvas 响应鼠标/触摸事件              | [[01 六大基础组件]] |
| **EventSystem**             | 全局事件管理器，场景唯一                         | [[01 六大基础组件]] |
| **Standalone Input Module** | 处理键盘/鼠标输入                            | [[01 六大基础组件]] |
| **Rect Transform**          | UI 元素的位置/尺寸/锚点，替代普通 Transform        | [[01 六大基础组件]] |

### 基础显示控件

| 控件            | 作用                      | 关键属性                                        | 所在文件          |
| ------------- | ----------------------- | ------------------------------------------- | ------------- |
| **Image**     | 显示 Sprite 图片            | Source Image / Color / Image Type / Filled  | [[02 三大基础控件]] |
| **Text**      | 显示文字（旧版）                | Font / Size / Alignment / Color / Rich Text | [[02 三大基础控件]] |
| **Raw Image** | 显示 Texture（大图/流媒体/渲染纹理） | Texture / UV Rect                           | [[02 三大基础控件]] |

### 交互控件

| 控件               | 作用                    | 事件                             | 所在文件        |
| ---------------- | --------------------- | ------------------------------ | ----------- |
| **Button**       | 可点击按钮                 | `onClick`                      | [[03 组合控件]] |
| **Toggle**       | 单选/多选框                | `onValueChanged(bool)`         | [[03 组合控件]] |
| **Toggle Group** | 管理一组 Toggle，实现单选效果    | —                              | [[03 组合控件]] |
| **Input Field**  | 文本输入框                 | `onValueChanged` / `onEndEdit` | [[03 组合控件]] |
| **Slider**       | 滑动条                   | `onValueChanged(float)`        | [[03 组合控件]] |
| **Scrollbar**    | 滚动条（通常配合 Scroll View） | `onValueChanged(float)`        | [[03 组合控件]] |
| **Scroll View**  | 可滚动区域                 | —                              | [[03 组合控件]] |
| **Dropdown**     | 下拉选择框                 | `onValueChanged(int)`          | [[03 组合控件]] |

### 特殊功能

| 功能                  | 方式                                                        | 所在文件                |
| ------------------- | --------------------------------------------------------- | ------------------- |
| **图集（减少Draw Call）** | Sprite Atlas，将多张图合并为一张贴图                                  | [[04 图集制作]]         |
| **UI 事件监听接口**       | 实现 `IPointerClickHandler` 等接口                             | [[05 UI事件监听接口]]     |
| **Event Trigger**   | 无需写代码，Inspector 直接配置事件响应                                  | [[05 UI事件监听接口]]     |
| **屏幕坐标→UI坐标**       | `RectTransformUtility.ScreenPointToLocalPointInRectangle` | [[06 屏幕坐标转UI相对坐标]]  |
| **Mask 遮罩**         | `Mask` 组件，按图片形状裁剪子元素                                      | [[07 Mask 遮罩]]      |
| **Rect Mask 2D**    | 矩形遮罩，性能优于 Mask，只能矩形                                       | [[07 Mask 遮罩]]      |
| **模型/粒子显示在UI前**     | 调整 Camera Depth 或 Canvas Sort Order                       | [[08 模型和粒子显示在UI之前]] |

### 自动布局组件

| 组件                          | 作用                      | 所在文件          |
| --------------------------- | ----------------------- | ------------- |
| **Horizontal Layout Group** | 子元素水平自动排列               | [[09 自动布局组件]] |
| **Vertical Layout Group**   | 子元素垂直自动排列               | [[09 自动布局组件]] |
| **Grid Layout Group**       | 子元素网格自动排列               | [[09 自动布局组件]] |
| **Content Size Fitter**     | 根据内容自动调整容器大小            | [[09 自动布局组件]] |
| **Layout Element**          | 设置单个元素的布局参数（最小/首选/弹性尺寸） | [[09 自动布局组件]] |

---

*最后更新：*
