
**【任务类型】场景搭建指导**

**【任务描述】 在 Unity 场景中搭建 StarForge 的基础运行环境：**
1. GameManager 对象挂载所有 Manager
2. 第一个铁矿石采集点 
3. 背包 UI 显示 

**【已完成脚本清单】 ResourceManager / InventoryManager / BuildingManager PowerManager / FuelManager / PollutionManager ClickCollector / TerrainExtractor ProcessingBuilding / RecipeData / MachineUI **

**【注意事项】** 我是初级 Unity 程序员，需要分步骤指导， 每步告诉我在哪里点击、拖什么、填什么值。

---

我来给你一步一步详细说明，每步都会告诉你**点哪里、拖什么、填什么值**。

## 第一阶段：创建 GameManager 对象并挂载所有 Manager

### 步骤 1 — 创建空对象

1. 在顶部菜单点击 **GameObject → Create Empty**
2. 左侧 **Hierarchy** 面板会出现一个叫 `GameObject` 的对象
3. 点击它，按 **F2**（或右键 → Rename），改名为 `GameManager`
4. 在右侧 **Inspector** 面板，点击 **Transform** 组件右边的三个点 → **Reset**，确保坐标归零

### 步骤 2 — 挂载所有 Manager 脚本

选中 `GameManager` 对象，在 **Inspector** 最底部点击 **Add Component**，逐一搜索并添加以下脚本：

|搜索关键词|脚本名称|
|---|---|
|`ResourceManager`|ResourceManager|
|`InventoryManager`|InventoryManager|
|`BuildingManager`|BuildingManager|
|`PowerManager`|PowerManager|
|`FuelManager`|FuelManager|
|`PollutionManager`|PollutionManager|

> ✅ 添加完成后，Inspector 里应该能看到 **6 个组件**堆叠在一起。

---

## 第二阶段：创建第一个铁矿石采集点

### 步骤 3 — 创建矿石地面对象

1. **Hierarchy** 右键 → **3D Object → Cube**
2. 改名为 `IronOre_Node_01`
3. 在 **Inspector → Transform** 填入：
    - **Position**：`X=0, Y=0.5, Z=0`
    - **Scale**：`X=1, Y=1, Z=1`

### 步骤 4 — 给矿石换颜色（方便识别）

1. 在底部 **Project** 面板，右键空白处 → **Create → Material**
2. 改名为 `Mat_IronOre`
3. 点击这个 Material，在 Inspector 里点 **Albedo** 右边的**白色色块**
4. 颜色选 **深灰色带红**（铁矿石感觉），比如 R:120 G:80 B:60
5. 把 `Mat_IronOre` **拖到场景里的 Cube 上**

### 步骤 5 — 挂载采集脚本

1. 选中 `IronOre_Node_01`
2. **Add Component** → 搜索 `ClickCollector` → 添加
3. 在 ClickCollector 组件里找到以下字段并填写：

|字段名|填写内容|
|---|---|
|`Resource Type`|`Iron`（或你脚本里定义的铁矿枚举值）|
|`Amount Per Click`|`5`|
|`Collector Name`|`铁矿石采集点`|

> ⚠️ **字段名可能略有不同**，取决于你的脚本变量名。打开 `ClickCollector.cs`，看 `[SerializeField]` 下面的变量名，对号入座填写。

### 步骤 6 — 确保矿石有 Collider（不然点击没反应）

选中 `IronOre_Node_01`，Inspector 里确认有 **Box Collider** 组件（Cube 默认自带），如果没有：

- **Add Component → Box Collider**

---

## 第三阶段：创建背包 UI

### 步骤 7 — 创建 Canvas

1. **Hierarchy** 右键 → **UI → Canvas**
2. 选中 Canvas，Inspector 里：
    - **Render Mode** 改为 `Screen Space - Overlay`
    - **UI Scale Mode** 改为 `Scale With Screen Size`
    - **Reference Resolution**：`X=1920, Y=1080`

### 步骤 8 — 创建背包面板

1. 右键 **Canvas** → **UI → Panel**
2. 改名为 `InventoryPanel`
3. 选中它，**Rect Transform** 填写：

|字段|值|
|---|---|
|**Anchor**|右下角（点 Anchor Presets 图标 → 按住 Alt 点右下角）|
|**Width**|`350`|
|**Height**|`500`|
|**Pos X**|`-20`|
|**Pos Y**|`20`|

### 步骤 9 — 添加背包标题

1. 右键 `InventoryPanel` → **UI → Text - TextMeshPro**（如果弹窗问导入 TMP，点 **Import TMP Essentials**）
2. 改名为 `Title_Inventory`
3. Inspector 里：
    - **Text** 内容填：`📦 背包`
    - **Font Size**：`24`
    - **Alignment**：水平居中、垂直居中
    - **Rect Transform**：拖到面板顶部，Height 约 `50`

### 步骤 10 — 创建物品槽容器

1. 右键 `InventoryPanel` → **UI → Scroll View**
2. 改名为 `ItemScrollView`
3. 调整大小填满面板下方区域
4. 展开 `ItemScrollView → Viewport → Content`，选中 **Content** 对象：
    - **Add Component → Grid Layout Group**
    - 填写：**Cell Size** `X=80, Y=80`，**Spacing** `X=5, Y=5`

### 步骤 11 — 把 InventoryManager 关联到 UI

1. 选中 `GameManager` 对象
2. 找到 **InventoryManager** 组件
3. 将字段（通常叫 `inventoryPanel` 或 `uiRoot`）**拖入 `InventoryPanel`**
4. 将 `Content` 对象拖入 `itemContainer` 或类似字段

> ⚠️ 同样，打开 `InventoryManager.cs` 看 `[SerializeField]` 变量名再对应拖拽。

---

## 最终检查清单

运行前，按下面逐项确认：

```
☐ Hierarchy 里有 GameManager，Inspector 能看到 6 个 Manager 组件
☐ IronOre_Node_01 有 ClickCollector + Box Collider
☐ Canvas 下有 InventoryPanel
☐ InventoryManager 的 UI 引用字段已拖拽赋值
☐ 点击 Play，点击矿石，背包数量变化
```

---

## 常见报错速查

|报错信息|原因|解决方法|
|---|---|---|
|`NullReferenceException` on InventoryManager|UI 引用没拖|检查步骤 11|
|点矿石没反应|没有 Collider 或缺 Camera 的 Physics Raycaster|给 Camera 加 **Physics Raycaster** 组件|
|Manager 找不到对方|没有用 `GetComponent` 或单例|确保所有 Manager 都在同一 GameManager 对象上|

---

如果你把 `ClickCollector.cs` 或 `InventoryManager.cs` 的代码贴给我，我可以**精准告诉你每个字段叫什么名字、该填什么**，不用靠猜了！

---

# 我

这个项目是2D项目

---

# Claude

## StarForge 基础场景搭建指南（2D 版）

感谢补充！2D 项目有几个关键区别，我来重新给你完整的步骤。

---

### ⚠️ 2D 与 3D 的核心区别

|项目|3D|2D|
|---|---|---|
|矿石对象|Cube|**Sprite**|
|碰撞体|Box Collider|**Box Collider 2D**|
|摄像机|Perspective|**Orthographic**|
|点击检测|Physics Raycaster|**Physics 2D Raycaster**|
|刚体|Rigidbody|**Rigidbody 2D**|

---

### 第一阶段：确认项目是 2D 模式

#### 步骤 1 — 检查摄像机设置

1. 在 **Hierarchy** 点击 **Main Camera**
2. Inspector 里找 **Camera** 组件
3. 确认 **Projection** 是 `Orthographic`（不是 Perspective）
4. **Size** 填 `5`（控制视野大小，之后可调）

#### 步骤 2 — 给摄像机加 2D 点击检测

1. 还是选中 **Main Camera**
2. **Add Component** → 搜索 `Physics 2D Raycaster` → 添加
3. 不需要填任何值，默认即可

> ✅ 没有这个组件，点击矿石**完全没反应**，这步很关键！

---

### 第二阶段：创建 GameManager

#### 步骤 3 — 创建空对象

1. **Hierarchy** 右键 → **Create Empty**
2. 改名为 `GameManager`
3. Inspector → Transform → 右键 → **Reset**（坐标归零）

#### 步骤 4 — 挂载所有 Manager 脚本

选中 `GameManager`，**Add Component** 逐一添加：

|搜索词|添加脚本|
|---|---|
|ResourceManager|ResourceManager|
|InventoryManager|InventoryManager|
|BuildingManager|BuildingManager|
|PowerManager|PowerManager|
|FuelManager|FuelManager|
|PollutionManager|PollutionManager|

---

### 第三阶段：创建铁矿石采集点（2D Sprite）

#### 步骤 5 — 创建 Sprite 对象

1. **Hierarchy** 右键 → **2D Object → Sprite**
2. 改名为 `IronOre_Node_01`
3. Inspector → **Transform** 填：
    - **Position**：`X=0, Y=0, Z=0`
    - **Scale**：`X=1, Y=1, Z=1`

#### 步骤 6 — 设置矿石图片

**如果你有矿石图片：**

1. 把图片拖进 **Project → Assets** 文件夹
2. 点击图片，Inspector 里 **Texture Type** 改为 `Sprite (2D and UI)` → 点 **Apply**
3. 把图片从 Project 面板**拖到场景里的 IronOre_Node_01 上**

**如果暂时没有图片（用纯色代替）：**

1. 选中 `IronOre_Node_01`
2. Inspector → **Sprite Renderer → Color**，点色块改成深棕色（R:139 G:90 B:43）
3. **Sprite** 字段选 `Knob` 或 `UISprite`（Unity 内置的白色圆/方块临时用）

#### 步骤 7 — 添加 2D 碰撞体（必须！）

1. 选中 `IronOre_Node_01`
2. **Add Component** → 搜索 `Box Collider 2D` → 添加
3. 默认大小会自动匹配 Sprite，不需要手动调

> ⚠️ **不要**加 `Box Collider`（3D版），一定要加 `Box Collider 2D`！

#### 步骤 8 — 挂载采集脚本

1. 选中 `IronOre_Node_01`
2. **Add Component** → 搜索 `ClickCollector` → 添加
3. 根据你脚本里的字段填写（打开 `ClickCollector.cs` 对照）：

|常见字段名|填写内容|
|---|---|
|`resourceType`|`Iron`（铁矿枚举值）|
|`amountPerClick`|`5`|
|`nodeName`|`铁矿石采集点`|

---

### 第四阶段：背包 UI

#### 步骤 9 — 创建 Canvas

1. **Hierarchy** 右键 → **UI → Canvas**
2. 选中 Canvas，Inspector 里：
    - **Render Mode**：`Screen Space - Overlay`
    - **UI Scale Mode**：`Scale With Screen Size`
    - **Reference Resolution**：`X=1920, Y=1080`

#### 步骤 10 — 创建背包面板

1. 右键 **Canvas** → **UI → Panel**
2. 改名为 `InventoryPanel`
3. 选中它，点 **Rect Transform** 左上角的**锚点图标（方块图案）**
4. 按住 `Alt` 键，点击**右下角**的锚点预设
5. 然后手动填写：

|字段|值|
|---|---|
|Width|`350`|
|Height|`500`|
|Pos X|`-20`|
|Pos Y|`20`|

#### 步骤 11 — 添加标题文字

1. 右键 `InventoryPanel` → **UI → Text - TextMeshPro**
    - 弹出窗口点 **Import TMP Essentials**
2. 改名为 `Txt_Title`
3. Inspector 填：
    - **Text**：`背包`
    - **Font Size**：`24`
    - **Alignment**：点居中图标（横向+纵向都居中）
4. **Rect Transform**：拖到面板顶部，Height 约 `50`

#### 步骤 12 — 创建物品列表区域

1. 右键 `InventoryPanel` → **UI → Scroll View**
2. 改名为 `ItemScrollView`
3. 调整大小，占满面板标题以下区域
4. 展开层级：`ItemScrollView → Viewport → Content`
5. 选中 **Content**，**Add Component → Grid Layout Group**
6. 填写：
    - **Cell Size**：`X=80, Y=80`
    - **Spacing**：`X=5, Y=5`
    - **Constraint**：`Fixed Column Count`，Count = `3`

#### 步骤 13 — 关联 UI 到 InventoryManager

1. 选中 **GameManager**
2. 找到 **InventoryManager** 组件
3. 将 `InventoryPanel` 对象从 Hierarchy **拖到对应字段**
4. 将 `Content` 对象拖到 `itemContainer` 类字段

---

### 最终运行检查

```
☐ Main Camera → Projection = Orthographic
☐ Main Camera → 有 Physics 2D Raycaster 组件
☐ GameManager → 有 6 个 Manager 组件
☐ IronOre_Node_01 → 有 Sprite Renderer
☐ IronOre_Node_01 → 有 Box Collider 2D（注意是2D！）
☐ IronOre_Node_01 → 有 ClickCollector，字段已填值
☐ Canvas 下有 InventoryPanel
☐ InventoryManager 的 UI 字段已拖拽赋值
```

点击 **Play**，然后鼠标点击矿石，看背包数量是否变化 ✅

---

把你的 `ClickCollector.cs` 代码贴给我，我可以告诉你**精确的字段名**，省去猜测！

---

# 我

背包脚本没有关联UI的成员变量，代码给你看一下

---

# Claude

## 明白了！InventoryManager 是纯数据层

看完代码，它的设计是**事件驱动**的——靠 `OnItemChanged` 事件通知 UI，而不是自己持有 UI 引用。

所以步骤 13 的"拖拽赋值"**不适用**，你需要另写一个 UI 脚本来监听它。

---

### 正确做法：新建 InventoryUI.cs

#### 步骤 1 — 创建脚本

在 **Project 面板** 右键 → **Create → C# Script**，命名为 `InventoryUI`，粘贴以下代码：

```csharp
// Assets/_StarForge/Scripts/UI/InventoryUI.cs
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections.Generic;

public class InventoryUI : MonoBehaviour
{
    [Header("UI 引用")]
    [SerializeField] private Transform itemContainer;   // 拖 Content 对象
    [SerializeField] private GameObject itemSlotPrefab; // 拖物品槽预制体

    // 缓存已创建的槽位，避免重复创建
    private Dictionary<string, TextMeshProUGUI> slotTexts = new();

    void Start()
    {
        // 订阅背包变化事件
        InventoryManager.Instance.OnItemChanged += OnItemChanged;

        // 初始化时刷新一次（防止进场景已有数据没显示）
        RefreshAll();
    }

    void OnDestroy()
    {
        // 取消订阅，防止内存泄漏
        if (InventoryManager.Instance != null)
            InventoryManager.Instance.OnItemChanged -= OnItemChanged;
    }

    // 单个物品变化时调用
    private void OnItemChanged(string resourceId, float newAmount)
    {
        if (slotTexts.TryGetValue(resourceId, out var text))
        {
            // 槽位已存在，直接更新数量
            text.text = $"{resourceId}\n{newAmount}";
        }
        else
        {
            // 新物品，创建一个新槽位
            CreateSlot(resourceId, newAmount);
        }
    }

    // 全量刷新（初始化用）
    private void RefreshAll()
    {
        var allItems = InventoryManager.Instance.GetAllItems();
        foreach (var kvp in allItems)
            CreateSlot(kvp.Key, kvp.Value);
    }

    // 创建一个物品槽
    private void CreateSlot(string resourceId, float amount)
    {
        if (itemSlotPrefab == null || itemContainer == null) return;

        var slot = Instantiate(itemSlotPrefab, itemContainer);
        slot.name = $"Slot_{resourceId}";

        var text = slot.GetComponentInChildren<TextMeshProUGUI>();
        if (text != null)
        {
            text.text = $"{resourceId}\n{amount}";
            slotTexts[resourceId] = text;
        }
    }
}
```

---

### 步骤 2 — 创建物品槽预制体

1. **Hierarchy** 右键 Canvas → **UI → Image**，改名为 `ItemSlot`
2. Inspector → Image → **Color**：深色半透明（R:50 G:50 B:50 A:200）
3. **Rect Transform → Width/Height**：`80 × 80`
4. 右键 `ItemSlot` → **UI → Text - TextMeshPro**，改名为 `Txt_Item`
5. Txt_Item 的 **Rect Transform** → 锚点选**全拉伸（Alt+中间）**，四边 Offset 都填 `5`
6. 字体大小 `14`，对齐**居中**
7. 把 `ItemSlot` **拖到 Project 面板**变成预制体（Prefab）
8. **删掉 Hierarchy 里的 ItemSlot**（保留 Prefab 就够了）

---

### 步骤 3 — 挂载并赋值 InventoryUI

1. 选中 **InventoryPanel**（Canvas 下的那个）
2. **Add Component** → 搜索 `InventoryUI` → 添加
3. 赋值两个字段：

|字段|拖什么|
|---|---|
|`Item Container`|Hierarchy 里的 `Content` 对象|
|`Item Slot Prefab`|Project 面板里的 `ItemSlot` 预制体|

---

### 整体数据流

```
玩家点击矿石
    ↓
ClickCollector.cs
    ↓  调用
InventoryManager.Add("iron", 5)
    ↓  触发事件
OnItemChanged("iron", 5)
    ↓  监听事件
InventoryUI.OnItemChanged()
    ↓
背包 UI 自动刷新 ✅
```

---

把你的 `ClickCollector.cs` 也贴给我，我帮你确认它调用的是 `InventoryManager.Add()` 还是别的方法！

---

# 我

`InventoryManager` 和 UI 的关联方式是事件驱动，UI 不主动查询数据，而是订阅事件等待通知。 关联方式 `InventoryManager` 有一个公开事件：

```csharp
public event Action<string, float> OnItemChanged;

```

每当背包里任何物品数量变化时，这个事件就会触发，传出两个参数：

- `string`：变化的资源 ID，比如 `"ore_iron"`
- `float`：变化后的新数量 UI 脚本需要做的三件事 第一：订阅事件 在 UI 脚本的 `Start()` 里：

```csharp
void Start()
{
    InventoryManager.Instance.OnItemChanged += OnItemChanged;
    RefreshAll(); // 初始化时刷新一次全部显示
}

```

第二：取消订阅（防内存泄漏） 在 UI 脚本的 `OnDestroy()` 里：

```csharp
void OnDestroy()
{
    if (InventoryManager.Instance != null)
        InventoryManager.Instance.OnItemChanged -= OnItemChanged;
}

```

第三：响应事件，更新显示

```csharp
void OnItemChanged(string resourceId, float newAmount)
{
    // 只更新变化的那一行，不刷新整个列表
    // 根据 resourceId 找到对应的 UI 行，更新数字
}

```

初始化全部显示 UI 第一次显示时需要遍历所有背包物品：

```csharp
void RefreshAll()
{
    var allItems = InventoryManager.Instance.GetAllItems();
    foreach (var kvp in allItems)
    {
        // kvp.Key = resourceId
        // kvp.Value = 数量
        // 用 ResourceManager.Instance.GetDisplayName(kvp.Key) 获取中文名
    }
}

```

一句话总结 UI 在 `Start()` 里订阅 `OnItemChanged` 事件，收到通知时更新对应行的数字；`OnDestroy()` 里取消订阅。不需要在 `Update()` 里每帧查询。 把这个转告过去，如果那边还有具体问题再传回来。

---

# Claude

好的！你描述的架构和我上一版代码**完全吻合**，只需要一处小升级——在显示时用 `GetDisplayName()` 取中文名，而不是直接显示资源 ID。

把 `InventoryUI.cs` 里这两行改一下：

```csharp
// 改前（显示原始 ID，比如 "ore_iron"）
text.text = $"{resourceId}\n{amount}";

// 改后（显示中文名，比如 "铁矿石"）
string displayName = ResourceManager.Instance.GetDisplayName(resourceId);
text.text = $"{displayName}\n{amount}";
```

**两处都要改**，`OnItemChanged` 和 `CreateSlot` 方法里各一处：

```csharp
private void OnItemChanged(string resourceId, float newAmount)
{
    string displayName = ResourceManager.Instance.GetDisplayName(resourceId);
    
    if (slotTexts.TryGetValue(resourceId, out var text))
    {
        text.text = $"{displayName}\n{newAmount}";  // ← 改这里
    }
    else
    {
        CreateSlot(resourceId, newAmount);
    }
}

private void CreateSlot(string resourceId, float amount)
{
    if (itemSlotPrefab == null || itemContainer == null) return;

    var slot = Instantiate(itemSlotPrefab, itemContainer);
    slot.name = $"Slot_{resourceId}";

    var text = slot.GetComponentInChildren<TextMeshProUGUI>();
    if (text != null)
    {
        string displayName = ResourceManager.Instance.GetDisplayName(resourceId);
        text.text = $"{displayName}\n{amount}";  // ← 改这里
        slotTexts[resourceId] = text;
    }
}
```

---

其余结构完全不变，整体数据流确认如下：

```
InventoryManager.Add("ore_iron", 5)
    ↓ 触发
OnItemChanged("ore_iron", 5.0f)
    ↓ UI 收到
GetDisplayName("ore_iron") → "铁矿石"
    ↓
显示："铁矿石 / 5" ✅
```

下一步把 `ClickCollector.cs` 贴给我，确认它调用的是 `InventoryManager.Add()` 还是走了别的路径。

---

# 我

amount 从哪传进来的？

```csharp
private void OnItemChanged(string resourceId, float newAmount)
    {
        if (slotTexts.TryGetValue(resourceId, out var text))
        {
            // 槽位已存在，直接更新数量
            // 改后（显示中文名，比如 "铁矿石"）
            string displayName = ResourceManager.Instance.GetDisplayName(resourceId);
            text.text = $"{displayName}\n{amount}";
        }
        else
        {
            // 新物品，创建一个新槽位
            CreateSlot(resourceId, newAmount);
        }
    }

```

---

# Claude

你发现了一个 **Bug**！是我的笔误。

`amount` 根本没有传进来，那个方法的参数名是 `newAmount`，应该用 `newAmount`。

**改法：**

```csharp
// 错误（amount 未定义，会报编译错误）
text.text = $"{displayName}\n{amount}";

// 正确（用参数 newAmount）
text.text = $"{displayName}\n{newAmount}";
```

---

完整正确版本：

```csharp
private void OnItemChanged(string resourceId, float newAmount)
{
    string displayName = ResourceManager.Instance.GetDisplayName(resourceId);

    if (slotTexts.TryGetValue(resourceId, out var text))
    {
        text.text = $"{displayName}\n{newAmount}";  // ✅ newAmount
    }
    else
    {
        CreateSlot(resourceId, newAmount);
    }
}
```

---

**为什么会有这种错误？**

合并两段代码时，一段用的是 `amount`，另一段用的是 `newAmount`，拼在一起时没有统一变量名。以后遇到类似报错：

```
error CS0103: The name 'amount' does not exist in the current context
```

就是这种情况——**变量名对不上**，查一下方法参数叫什么就能找到。

---

# 我

你之后写代码也跟这样，在前面注释这个脚本的用途，方法和重要属性都注释好

---

# Claude

收到！以后我写的所有脚本都会按这个风格注释：

```
// 文件头：脚本职责、设计分工、使用场景
// [Header] 分组属性
// 每个公开方法写 <summary>
// 关键逻辑行内注释
```

---

顺便确认了 `ClickCollector.cs` 的接入情况，**完全没问题**：

|检查项|结果|
|---|---|
|调用 `InventoryManager.Instance.Add()`|✅ 第 `TryCollect()` 方法里|
|用了 `Physics2D.Raycast`|✅ 2D 点击检测正确|
|有 `clickCooldown` 防连点|✅|
|矿藏耗尽有提示|✅ `ShowFloatingText("资源已耗尽")`|

---

**Unity 里 `IronOre_Node_01` 需要填的字段**，现在可以精确告诉你了：

|Inspector 字段|填写值|
|---|---|
|`Mode`|`Normal`|
|`Resource Id`|`ore_iron`|
|`Collect Amount Per Click`|`1`（或你想要的数量）|
|`Click Cooldown`|`0.2`|
|`Buffer Capacity`|`100`|
|`Floating Text Prefab`|暂时留空（没有飘字预制体就不填）|
|`Floating Text Spawn Pos`|暂时留空|

`ResourceId` 一定要填 `ore_iron`，和 `ResourceManager` 里定义的 ID 对上，`GetDisplayName()` 才能返回正确的中文名。

---

# 我

生成 Git的Commit

---

# Claude

commit message 遵循 **Conventional Commits** 规范：`feat(scope): 简短描述`。

如果你的项目有中文 commit 习惯，也可以改成：

```
feat(场景): 搭建 GameManager、铁矿采集点与背包UI基础框架
```

两种写法都行，保持项目内统一就好。