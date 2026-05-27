# 开发日志 · Day 2
**日期：** 2026-05-08  
**实际开发时长：** 约 4 小时  
**里程碑：** M2 进行中

---

## 今日完成

### 设计决策
- [x] 资源系统重构：自然资源 vs 加工产物框架分离定稿
- [x] 矿石加工链定稿（四条路线，副产物规则全部明确）
- [x] 宝石类加工路线定稿（筛选机路线，过渡采矿机直出成品）
- [x] 加工产物命名规范确立（`crushed_/powder_/ingot_`等前缀规范）
- [x] 熔岩资源修正：从"类水无限"改为"类原油有限地形采集"
- [x] 机器缓存系统设计：输入缓存+输出缓存，缓存满停机
- [x] 副产物槽位设计：独立缓存槽，不直接进背包
- [x] 手搓配方加入RecipeData，支持背包内合成
- [x] 架构重构：引入InventoryManager，ResourceManager只管世界数据

### 代码实现
- [x] InventoryManager（玩家背包，测试阶段无限容量）
- [x] ResourceManager v4（修复熔岩分类，注册63种加工产物ID）
- [x] RecipeData v2（新增手搓配方字段：isCraftable/craftingCategory/craftingTime）
- [x] ProcessingBuilding v3（输入/输出双缓存，副产物独立输出槽）
- [x] TerrainExtractor（地形采集机：抽水机/采油机/熔岩泵通用脚本）
- [x] ClickCollector v3（采集点模式，产物进背包，区分Normal/Terrain）
- [x] BuildingManager v3（建造费用从InventoryManager扣除）
- [x] MachineUI v2（对齐新API，多输出槽动态显示，含副产物槽）

---

## 今日踩坑

| 坑 | 原因 | 解决方案 |
|----|------|---------|
| MachineUI编译错误CS1061 | ProcessingBuilding更新了API，MachineUI仍调用旧方法名`CollectOutput` | 整体更新MachineUI对齐新API：`CollectAllOutput()`/`GetAllOutputSlots()` |
| 遍历Dictionary时修改报错 | `CollectAllOutput()`直接遍历OutputBuffer同时删除key | 先`new List<string>(OutputBuffer.Keys)`复制key列表再遍历 |

---

## 学到的概念

### 设计模式

**状态机（State Machine）**  
ProcessingBuilding的四个状态：Off/Idle/Processing/OutputFull。  
每帧只执行当前状态的逻辑，状态切换有明确条件。  
相比一堆bool组合（isOn/isProcessing/isFull），状态机消除了非法状态组合，逻辑清晰好调试。

```csharp
// bool组合有8种组合，其中很多是非法的
bool isOn, isProcessing, isFull;

// 状态机只有4个合法状态
enum MachineState { Off, Idle, Processing, OutputFull }
```

**策略模式（Strategy Pattern）**  
ProcessingBuilding不知道自己在加工什么，把"如何加工"委托给RecipeData。  
切换配方 = 切换策略，机器代码一行不改。  
50种配方，1个脚本搞定，这就是数据驱动的价值。

**观察者模式（Observer Pattern）**（复习）  
ProcessingBuilding用event广播状态变化（OnStateChanged/OnBufferChanged），  
MachineUI订阅这些事件来刷新显示，两者完全解耦。  
好处：以后换UI框架，只需要改MachineUI，不动ProcessingBuilding。

### 架构概念

**单一职责原则**  
ResourceManager只管世界数据（矿藏储量），不管玩家有什么。  
InventoryManager只管玩家背包，不关心世界怎么运转。  
两者分离后，"玩家有多少铁矿"和"世界还剩多少铁矿"是两个独立的问题。

**System.Random vs Unity Random**  
副产物概率用`System.Random`而非`Unity.Random.value`，原因：  
- `System.Random`可在非主线程使用（为未来异步加工预留）  
- 不依赖Unity生命周期，可在任意时机实例化  
- 性能上在批量计算时略优于Unity Random

---

## 当前技术债
- [ ] ResourceUI 仍监听 ResourceManager.OnResourceChanged，需改为监听 InventoryManager.OnItemChanged
- [ ] MachineUI 的输出槽预制体（outputSlotPrefab）需在Unity里配置层级结构
- [ ] FuelManager Inspector 里的燃料列表需手动更新为真实资源ID
- [ ] RecipeData.IsUnlocked() 有 TODO，等 TechTreeManager 实现后接入
- [ ] 所有加工配方的 ScriptableObject 文件需要逐一创建（当前只有测试用的crush_iron_basic）

---

## 下次开发计划
- [ ] 创建地球篇完整配方文件（至少铁矿石完整链条可测试）
- [ ] 在场景中搭建第一台粉碎机并测试完整加工流程
- [ ] 讨论并开始设计科技树系统
- [ ] 修复技术债：ResourceUI改为监听背包

---

*下次开发前先看"下次开发计划"和"当前技术债"*
